// class_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class.dart';
import '../models/student.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ClassModel>> getClasses() async {
    final querySnapshot = await _firestore.collection('classes').get();
    return querySnapshot.docs.map((doc) => ClassModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addClass(ClassModel classModel) async {
    await _firestore.collection('classes').doc(classModel.id).set(classModel.toMap());
  }

  Future<void> deleteClass(String classId) async {
    await _firestore.collection('classes').doc(classId).delete();
  }

  Future<List<StudentModel>> getStudents(String classId) async {
    final querySnapshot = await _firestore.collection('classes').doc(classId).collection('students').get();
    return querySnapshot.docs.map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
