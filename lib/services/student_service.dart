// student_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StudentModel>> getStudents(String classId) async {
    final querySnapshot = await _firestore.collection('classes').doc(classId).collection('students').get();
    print(querySnapshot.toString());
    return querySnapshot.docs.map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addStudent(String classId, StudentModel student) async {
    await _firestore.collection('classes').doc(classId).collection('students').doc(student.id).set(student.toMap());
  }

  Future<void> deleteStudent(String classId, String studentId) async {
    await _firestore.collection('classes').doc(classId).collection('students').doc(studentId).delete();
  }
}
