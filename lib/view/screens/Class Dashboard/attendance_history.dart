import 'package:flutter/material.dart';
import 'attendance_percentage.dart'; // Import the Attendance Percentages Screen
import '../../../models/attendance.dart';
import '../../../services/attendance_service.dart';
import '../../constants/theme.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final String className;

  const AttendanceHistoryScreen({required this.className, Key? key}) : super(key: key);

  @override
  _AttendanceHistoryScreenState createState() => _AttendanceHistoryScreenState();
}
 
class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceModel>? _attendanceRecords;
  Map<String, double>? _attendancePercentages;
  AttendanceModel? _selectedRecord;
  
  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory(widget.className);
  }

  Future<void> _loadAttendanceHistory(String className) async {
    final records = await _attendanceService.getAttendanceHistory(className);
    setState(() {
      _attendanceRecords = records.isEmpty ? [] : records;
      _attendancePercentages = AttendanceModel.calculateAttendancePercentages(records);
      if (_attendanceRecords!.isNotEmpty) {
        _selectedRecord = _attendanceRecords![0]; // Default to the first record
      }
    });
  }

  void _onDateSelected(AttendanceModel record) {
    setState(() {
      _selectedRecord = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance History for ${widget.className}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: _attendanceRecords == null
          ? Center(child: CircularProgressIndicator())
          : _attendanceRecords!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_accounts_rounded, color: Colors.grey, size: 40),
                      SizedBox(height: 16),
                      Text(
                        'No Attendance Record Found',
                        style: TextStyle(
                            color: textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'There is no attendance record for this class at this moment.',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Go Back'),
                        style: ElevatedButton.styleFrom(
                          primary: uddeshhyacolor, // Background color
                          onPrimary: textcolor, // Text color
                          elevation: 5, // Shadow depth
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Rounded corners
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Horizontally scrollable list of dates
                    Container(
                      height: 80, // Adjust height as needed
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _attendanceRecords!.map((record) {
                          return GestureDetector(
                            onTap: () => _onDateSelected(record),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: _selectedRecord == record ? Colors.blue : Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${record.date.toLocal()}'.split(' ')[0],
                                  style: TextStyle(
                                    color: _selectedRecord == record ? Colors.white : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Display attendance for the selected date
                    Expanded(
                      child: _selectedRecord == null
                          ? Center(
                              child: Text(
                                'No Record Selected',
                                style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView(
                                children: _selectedRecord!.studentAttendance.entries.map((entry) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    title: Text(
                                      entry.key,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    trailing: Text(
                                      entry.value ? 'Present' : 'Absent',
                                      style: TextStyle(
                                        color: entry.value ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    tileColor: Colors.grey[850],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_attendancePercentages != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AttendancePercentagesScreen(attendancePercentages: _attendancePercentages!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Attendance percentages are not available.'),
                            ),
                          );
                        }
                      },
                      child: Text('View Attendance Percentages'),
                      style: ElevatedButton.styleFrom(
                        primary: uddeshhyacolor, // Background color
                        onPrimary: textcolor, // Text color
                        elevation: 5, // Shadow depth
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                      ),
                    ),
                  ],
                ),
    );
  }
}
