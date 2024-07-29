// syllabus_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/syllabus.dart';

class SyllabusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SyllabusModel>> getSyllabi() async {
    final querySnapshot = await _firestore.collection('syllabus').get();
    return querySnapshot.docs.map((doc) => SyllabusModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addSyllabus(SyllabusModel syllabus) async {
    await _firestore.collection('syllabus').doc(syllabus.standard).set(syllabus.toMap());
  }

  Future<void> updateSyllabus(SyllabusModel syllabus) async {
    await _firestore.collection('syllabus').doc(syllabus.standard).update(syllabus.toMap());
  }
}
