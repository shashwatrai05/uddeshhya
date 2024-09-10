import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/attendance.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitAttendance(BuildContext context, String className,
      DateTime date, Map<String, bool> studentAttendance) async {
    // Normalize date to only year, month, and day to avoid issues with time portion
    final normalizedDate = DateTime(date.year, date.month, date.day);
    print(': jdfhdufkhfdfhkfhdfskfgewiufkjdfdjfd');
    print(Timestamp.fromDate(normalizedDate));

    // Check if attendance has already been submitted for this class and normalized date
    final querySnapshot = await _db
        .collection('attendance')
        .where('className', isEqualTo: className)
        .where('date', isEqualTo: Timestamp.fromDate(normalizedDate))
        .get();

    print('88384854557575948754895749534');

    // If a record is found, show a message and prevent duplicate attendance
    if (querySnapshot.docs.isNotEmpty) {
      print('Query not empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Attendance has already been taken for this class on the selected date.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; // Prevent submission
    }

    // If no record exists, submit the attendance
    await _db.collection('attendance').add({
      'className': className,
      'date': Timestamp.fromDate(normalizedDate),
      'studentAttendance': studentAttendance,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<List<AttendanceModel>> getAttendanceHistory(String className) async {
    final querySnapshot = await _db
        .collection('attendance')
        .where('className', isEqualTo: className)
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => AttendanceModel.fromFirestore(doc))
        .toList();
  }
}
