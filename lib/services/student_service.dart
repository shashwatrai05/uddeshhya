// student_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

// student_service.dart

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<List<StudentModel>> getStudents(String classId) async {
    final querySnapshot = await _firestore.collection('classes').doc(classId).collection('students').get();
    print(querySnapshot.toString());
    print(querySnapshot.docs.map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
    return querySnapshot.docs.map((doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>)).toList();

  }

  Future<void> addStudent(String classId, StudentModel student) async {
    await _firestore.collection('classes').doc(classId).collection('students').doc(student.id).set(student.toMap());
  }

  Future<void> deleteStudent(String classId, String studentId) async {
    await _firestore.collection('classes').doc(classId).collection('students').doc(studentId).delete();
  }

Future<Map<String, bool>> fetchSyllabusCompletion(String standard) async {
  print('Fetching syllabus for standard: $standard');
  final syllabusDoc = await _firestore.collection('syllabus').doc(standard).get();

  if (!syllabusDoc.exists) {
    print('No syllabus found for standard: $standard');
    return {}; // Return an empty map if no document exists
  }

  final topicsData = syllabusDoc.data()?['topics'];
  print('Topics data: $topicsData');

  // Ensure 'topics' is a list
  List<String> topics;
  if (topicsData is List) {
    topics = List<String>.from(topicsData);
  } else {
    topics = []; // Default to an empty list if the data is not a list
  }
  print('Topics: $topics');

  // Create a map with topics as keys and false as values
  return Map.fromIterable(topics, key: (item) => item, value: (_) => false);
}

}
