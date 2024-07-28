import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String className;
  final DateTime date;
  final Map<String, bool> studentAttendance; // Map of student names to attendance status

  AttendanceModel({
    required this.id,
    required this.className,
    required this.date,
    required this.studentAttendance,
  });

  factory AttendanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AttendanceModel(
      id: doc.id,
      className: data['className'],
      date: (data['date'] as Timestamp).toDate(),
      studentAttendance: Map<String, bool>.from(data['studentAttendance']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'date': Timestamp.fromDate(date),
      'studentAttendance': studentAttendance,
    };
  }

  static Map<String, double> calculateAttendancePercentages(List<AttendanceModel> records) {
    final Map<String, List<bool>> studentAttendanceMap = {};

    // Aggregate attendance records
    for (var record in records) {
      for (var entry in record.studentAttendance.entries) {
        if (!studentAttendanceMap.containsKey(entry.key)) {
          studentAttendanceMap[entry.key] = [];
        }
        studentAttendanceMap[entry.key]!.add(entry.value);
      }
    }

    // Calculate percentages
    final Map<String, double> percentages = {};
    for (var entry in studentAttendanceMap.entries) {
      final totalClasses = entry.value.length;
      final presentDays = entry.value.where((present) => present).length;
      final percentage = (presentDays / totalClasses) * 100;
      percentages[entry.key] = percentage;
    }

    return percentages;
  }
}
