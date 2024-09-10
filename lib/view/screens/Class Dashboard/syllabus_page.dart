import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/view/constants/theme.dart';

import '../../../models/student.dart';

class SyllabusPage extends StatefulWidget {
  final StudentModel student;
  final String classId;

  const SyllabusPage({super.key, required this.student, required this.classId});

  @override
  // ignore: library_private_types_in_public_api
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Syllabus updated successfully!')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update syllabus: $e')),
      );
    }
  }

  Future<void> _refreshSyllabus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('students')
          .doc(widget.student.id)
          .get();
      if (doc.exists) {
        setState(() {
          _updatedSyllabusCompletion =
              Map<String, bool>.from(doc.data()?['syllabusCompletion'] ?? {});
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh syllabus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.student.name}\'s Syllabus',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refreshSyllabus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _updatedSyllabusCompletion.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.no_accounts_rounded,
                                color: Colors.grey, size: 40),
                            const SizedBox(height: 16),
                            const Text(
                              'No Syllabus Added',
                              style: TextStyle(
                                  color: textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                'It looks like there are no Syllabus added for this class',
                                style: TextStyle(
                                    color: Colors.grey.shade300, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: textcolor,
                                  backgroundColor: uddeshhyacolor, // Text color
                                  elevation: 5, // Shadow depth
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12), // Padding
                                ),
                                child: const Text('Go Back')),
                          ],
                        ),
                      )
                    : ListView(
                        children:
                            _updatedSyllabusCompletion.entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CheckboxListTile(
                              title: Text(
                                entry.key,
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: entry.value,
                              onChanged: (value) {
                                setState(() {
                                  _updatedSyllabusCompletion[entry.key] =
                                      value ?? false;
                                });
                              },
                              checkColor: Colors.black,
                              activeColor: uddeshhyacolor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitSyllabus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uddeshhyacolor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Changes',
                    style: TextStyle(color: textcolor, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
