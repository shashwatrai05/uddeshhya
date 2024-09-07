import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/syllabus.dart';

class SyllabusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SyllabusModel>> getSyllabi() async {
    try {
      final querySnapshot = await _firestore.collection('syllabus').get();
      return querySnapshot.docs.map((doc) {
        // ignore: unnecessary_cast
        final data = doc.data() as Map<String, dynamic>;
        return SyllabusModel.fromMap(data);
      }).toList();
    } catch (e) {
      //print('Error getting syllabi: $e');
      return [];
    }
  }

  Future<SyllabusModel?> getSyllabus(String standard) async {
    try {
      final docSnapshot =
          await _firestore.collection('syllabus').doc(standard).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return SyllabusModel.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      // print('Error getting syllabus: $e');
      return null;
    }
  }

  Future<void> addSyllabus(SyllabusModel syllabus) async {
    try {
      await _firestore
          .collection('syllabus')
          .doc(syllabus.standard)
          .set(syllabus.toMap());
    } catch (e) {
      //  print('Error adding syllabus: $e');
    }
  }

  Future<void> updateSyllabus(SyllabusModel syllabus) async {
    try {
      print('Updating syllabus for: ${syllabus.standard}');
      print(
          'Topics to be saved: ${syllabus.topics.map((t) => t.title).toList()}'); // Debugging

      await _firestore
          .collection('syllabus')
          .doc(syllabus.standard)
          .set(syllabus.toMap());
    } catch (e) {
      print('Error updating syllabus: $e'); // Error logging
    }
  }

  Future<List<String>> getStandards() async {
    try {
      final snapshot = await _firestore.collection('syllabus').get();
      final standards = <String>[];
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('standard')) {
          standards.add(doc.data()['standard']);
        }
      }
      return standards;
    } catch (e) {
      // Handle errors as needed
      print('Error fetching standards: $e');
      return [];
    }
  }
}
