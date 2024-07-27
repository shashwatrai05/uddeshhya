import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../services/class_service.dart';
import '../services/attendance_service.dart';
import '../services/student_service.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ClassService _classService = ClassService();
  final StudentService _studentService = StudentService();
  final AttendanceService _attendanceService = AttendanceService();

  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  Map<String, bool> _attendance = {}; // Key is now studentName
  String? _selectedClassId;  // This will store the ID for selection
  String? _selectedClassName; // This will store the name for display
  DateTime _selectedDate = DateTime.now();

  // Create a map to link ids to names
  Map<String, String> _idToNameMap = {};

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await _classService.getClasses();
    setState(() {
      _classes = classes;
      _idToNameMap = Map.fromIterable(
        classes,
        key: (classModel) => classModel.id,
        value: (classModel) => classModel.name,
      );
    });
  }

  Future<void> _loadStudents() async {
    if (_selectedClassId != null) {
      final students = await _studentService.getStudents(_selectedClassId!);
      setState(() {
        _students = students;
        _attendance = {for (var student in students) student.name: false}; // Use student.name as key
      });
    }
  }

 void _submitAttendance() async {
  if (_selectedClassId != null) {
    // Create a map with student names and their attendance status
    final attendanceData = Map<String, bool>.from(_attendance);

    await _attendanceService.submitAttendance(
      _selectedClassName!,
      _selectedDate,
      attendanceData,
    );
    Navigator.pop(context);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedClassId,
              hint: const Text('Select Class'),
              onChanged: (value) {
                setState(() {
                  _selectedClassId = value;
                  _selectedClassName = _idToNameMap[value!];
                  _loadStudents();
                });
              },
              items: _classes.map((classModel) {
                return DropdownMenuItem<String>(
                  value: classModel.id,
                  child: Text(classModel.name),
                );
              }).toList(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Select Date'),
              readOnly: true,
              controller: TextEditingController(text: '${_selectedDate.toLocal()}'.split(' ')[0]),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null && date != _selectedDate) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            Expanded(
              child: ListView(
                children: _students.map((student) {
                  return CheckboxListTile(
                    title: Text(student.name),
                    value: _attendance[student.name],
                    onChanged: (value) {
                      setState(() {
                        _attendance[student.name] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _submitAttendance,
              child: const Text('Submit Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
