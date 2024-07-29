// add_syllabus_screen.dart

import 'package:flutter/material.dart';
import '../../models/syllabus.dart';
import '../../services/syllabus_service.dart';

class AddSyllabusScreen extends StatefulWidget {
  @override
  _AddSyllabusScreenState createState() => _AddSyllabusScreenState();
}

class _AddSyllabusScreenState extends State<AddSyllabusScreen> {
  final SyllabusService _syllabusService = SyllabusService();
  final TextEditingController _standardController = TextEditingController();
  final Map<String, bool> _topics = {};
  final TextEditingController _topicController = TextEditingController();

  void _addTopic() {
    final topic = _topicController.text.trim();
    if (topic.isNotEmpty) {
      setState(() {
        _topics[topic] = false;
        _topicController.clear();
      });
    }
  }

  void _saveSyllabus() async {
    final standard = _standardController.text.trim();
    if (standard.isNotEmpty && _topics.isNotEmpty) {
      // Convert topics map to a list of strings
      final topicsList = _topics.keys.toList();
      
      final syllabus = SyllabusModel(
        standard: standard,
        topics: topicsList, // Update to use list of topics
      );
      
      await _syllabusService.addSyllabus(syllabus);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Syllabus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _standardController,
              decoration: const InputDecoration(labelText: 'Standard'),
            ),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
            ElevatedButton(
              onPressed: _addTopic,
              child: const Text('Add Topic'),
            ),
            Expanded(
              child: ListView(
                children: _topics.keys.map((topic) {
                  return ListTile(
                    title: Text(topic),
                    trailing: Checkbox(
                      value: _topics[topic],
                      onChanged: (bool? value) {
                        setState(() {
                          _topics[topic] = value!;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _saveSyllabus,
              child: const Text('Save Syllabus'),
            ),
          ],
        ),
      ),
    );
  }
}
