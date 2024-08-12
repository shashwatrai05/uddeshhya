import 'package:flutter/material.dart';

class AttendanceList extends StatelessWidget {
  final Map<String, bool> studentAttendance;

  const AttendanceList({super.key, required this.studentAttendance});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: studentAttendance.entries.map((entry) {
        final studentName = entry.key;
        final isPresent = entry.value;
        return ListTile(
          title: Text(studentName),
          trailing: Text(isPresent ? 'Present' : 'Absent'),
        );
      }).toList(),
    );
  }
}
