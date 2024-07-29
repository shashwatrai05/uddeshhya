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
  final List<Topic> _topics = [];
  final TextEditingController _topicController = TextEditingController();

  void _addTopic() {
    final topicTitle = _topicController.text.trim();
    if (topicTitle.isNotEmpty) {
      setState(() {
        _topics.add(Topic(title: topicTitle, isCompleted: false));
        _topicController.clear();
      });
    }
  }

  void _saveSyllabus() async {
    final standard = _standardController.text.trim();
    if (standard.isNotEmpty && _topics.isNotEmpty) {
      final syllabus = SyllabusModel(
        standard: standard,
        topics: _topics, // Pass the list of Topic objects
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
              child: ListView.builder(
                itemCount: _topics.length,
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  return ListTile(
                    title: Text(topic.title),
                    trailing: Checkbox(
                      value: topic.isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          topic.isCompleted = value!;
                        });
                      },
                    ),
                    onLongPress: () {
                      setState(() {
                        _topics.removeAt(index);
                      });
                    },
                  );
                },
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
