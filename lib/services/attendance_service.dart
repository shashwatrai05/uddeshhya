import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';

class AttendanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitAttendance(String className, DateTime date, Map<String, bool> studentAttendance) async {
    await _db.collection('attendance').add({
      'className': className,
      'date': Timestamp.fromDate(date),
      'studentAttendance': studentAttendance,
    });
  }
Future<List<AttendanceModel>> getAttendanceHistory(String className) async {
    final querySnapshot = await _db.collection('attendance')
      .where('className', isEqualTo: className)
      .orderBy('date', descending: true)
      .get();

    return querySnapshot.docs.map((doc) => AttendanceModel.fromFirestore(doc)).toList();
  }
}