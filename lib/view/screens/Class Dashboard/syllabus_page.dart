import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/view/constants/theme.dart';

import '../../../models/student.dart';

class SyllabusPage extends StatefulWidget {
  final StudentModel student;
  final String classId;

  SyllabusPage({required this.student, required this.classId});

  @override
  _SyllabusPageState createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  late Map<String, bool> _updatedSyllabusCompletion;

  @override
  void initState() {
    super.initState();
    // Initialize with the student's current syllabus completion status
    _updatedSyllabusCompletion = Map.from(widget.student.syllabusCompletion);
  }

  Future<void> _submitSyllabus() async {
    try {
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('students')
          .doc(widget.student.id)
          .update({'syllabusCompletion': _updatedSyllabusCompletion});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Syllabus updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update syllabus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${widget.student.name}\'s Syllabus'),
      //   backgroundColor: Colors.black,
      // ),
      appBar: AppBar(
        title:Text(
          '${widget.student.name}\'s Syllabus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: _updatedSyllabusCompletion.entries.map((entry) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        title: Text(
                          entry.key,
                          style: TextStyle(color: Colors.white),
                        ),
                        value: entry.value,
                        onChanged: (value) {
                          setState(() {
                            _updatedSyllabusCompletion[entry.key] = value ?? false;
                          });
                        },
                        checkColor: Colors.black,
                        activeColor: uddeshhyacolor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitSyllabus,
                style: ElevatedButton.styleFrom(
                  primary: uddeshhyacolor,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit Changes',
                  style: TextStyle(color: textcolor, fontSize: 16),
                ),
              ),

            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
