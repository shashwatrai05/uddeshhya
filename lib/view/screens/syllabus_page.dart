import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/student.dart';

class SyllabusPage extends StatelessWidget {
  final StudentModel student;
  final String classId; // Add classId to manage Firestore updates

  SyllabusPage({required this.student, required this.classId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student.name}\'s Syllabus'),
      ),
      body: ListView(
        children: student.syllabusCompletion.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.key),
            value: entry.value,
            onChanged: (value) {
              // Update the syllabus completion status in Firestore
              final updatedCompletion = Map<String, bool>.from(student.syllabusCompletion)
                ..[entry.key] = value!;
              FirebaseFirestore.instance
                .collection('classes')
                .doc(classId) // Use the provided classId
                .collection('students')
                .doc(student.id)
                .update({'syllabusCompletion': updatedCompletion});
            },
          );
        }).toList(),
      ),
    );
  }
}
