import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/syllabus.dart';

class SyllabusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SyllabusModel>> getSyllabi() async {
    try {
      final querySnapshot = await _firestore.collection('syllabus').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SyllabusModel.fromMap(data);
      }).toList();
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore issues)
      print('Error getting syllabi: $e');
      return [];
    }
  }

  Future<void> addSyllabus(SyllabusModel syllabus) async {
    try {
      await _firestore.collection('syllabus').doc(syllabus.standard).set(syllabus.toMap());
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore issues)
      print('Error adding syllabus: $e');
    }
  }

  Future<void> updateSyllabus(SyllabusModel syllabus) async {
    try {
      await _firestore.collection('syllabus').doc(syllabus.standard).update(syllabus.toMap());
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore issues)
      print('Error updating syllabus: $e');
    }
  }
}
