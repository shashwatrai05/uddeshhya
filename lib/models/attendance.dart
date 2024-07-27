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
}


