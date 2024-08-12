import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';
import '../models/syllabus.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StudentModel>> getStudents(String classId) async {
    try {
      final querySnapshot = await _firestore.collection('classes').doc(classId).collection('students').get();
      return querySnapshot.docs.map((doc) {
        // ignore: unnecessary_cast
        final data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data);
      }).toList();
    } catch (e) {
      //print('Error getting students: $e');
      return [];
    }
  }

  Future<void> addStudent(String classId, StudentModel student) async {
    try {
      await _firestore.collection('classes').doc(classId).collection('students').doc(student.id).set(student.toMap());
    } catch (e) {
      //print('Error adding student: $e');
    }
  }

  Future<void> deleteStudent(String classId, String studentId) async {
    try {
      await _firestore.collection('classes').doc(classId).collection('students').doc(studentId).delete();
    } catch (e) {
      //print('Error deleting student: $e');
    }
  }

  Future<Map<String, bool>> fetchSyllabusCompletion(String standard) async {
    try {
      final syllabusDoc = await _firestore.collection('syllabus').doc(standard).get();

      if (!syllabusDoc.exists) {
       // print('No syllabus found for standard: $standard');
        return {}; // Return an empty map if no document exists
      }

      final topicsData = syllabusDoc.data()?['topics'];
      if (topicsData is List) {
        final topics = List<Topic>.from(
          topicsData.map((item) => Topic.fromMap(item as Map<String, dynamic>))
        );

        // Create a map with topics as keys and their completion statuses
        return {for (var topic in topics) topic.title: topic.isCompleted};
      } else {
        return {}; // Return an empty map if 'topics' is not a list
      }
    } catch (e) {
     // print('Error fetching syllabus completion: $e');
      return {}; // Return an empty map in case of error
    }
  }
}
