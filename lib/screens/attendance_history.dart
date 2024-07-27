import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/attendance.dart';
import '../services/class_service.dart';
import '../services/attendance_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  @override
  _AttendanceHistoryScreenState createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final ClassService _classService = ClassService();
  final AttendanceService _attendanceService = AttendanceService();

  List<ClassModel> _classes = [];
  List<AttendanceModel>? _attendanceRecords;
  String? _selectedClassName;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await _classService.getClasses();
    setState(() {
      _classes = classes;
    });
  }

  Future<void> _loadAttendanceHistory(String className) async {
    final records = await _attendanceService.getAttendanceHistory(className);
    setState(() {
      _attendanceRecords = records;
      _selectedClassName = className;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: _attendanceRecords == null
          ? ListView(
              children: _classes.map((classModel) {
                return ListTile(
                  title: Text(classModel.name),
                  onTap: () {
                    _loadAttendanceHistory(classModel.name);
                  },
                );
              }).toList(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance History for $_selectedClassName',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Expanded(
                    child: ListView(
                      children: _attendanceRecords!.map((record) {
                        return ExpansionTile(
                          title: Text('${record.date.toLocal()}'.split(' ')[0]),
                          children: record.studentAttendance.entries.map((entry) {
                            return ListTile(
                              title: Text(entry.key),
                              trailing: Text(entry.value ? 'Present' : 'Absent'),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _attendanceRecords = null;
                        _selectedClassName = null;
                      });
                    },
                    child: const Text('Back to Class List'),
                  ),
                ],
              ),
            ),
    );
  }
}
