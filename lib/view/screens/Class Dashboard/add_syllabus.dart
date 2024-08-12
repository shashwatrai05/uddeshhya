import 'package:flutter/material.dart';
import '../../../models/syllabus.dart';
import '../../../services/syllabus_service.dart';
import '../../constants/theme.dart';

class AddSyllabusScreen extends StatefulWidget {
  const AddSyllabusScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddSyllabusScreenState createState() => _AddSyllabusScreenState();
}

class _AddSyllabusScreenState extends State<AddSyllabusScreen> {
  final SyllabusService _syllabusService = SyllabusService();
  final TextEditingController _topicController = TextEditingController();
  final List<Topic> _topics = [];
  String _selectedStandard = '1st';
  String? _topicError;

  void _addTopic() {
    final topicTitle = _topicController.text.trim();
    if (topicTitle.isNotEmpty) {
      setState(() {
        _topics.add(Topic(title: topicTitle, isCompleted: false));
        _topicController.clear();
        _topicError = null;
      });
    } else {
      setState(() {
        _topicError = 'Topic cannot be empty';
      });
    }
  }

  void _saveSyllabus() async {
    if (_selectedStandard.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a standard.')),
      );
      return;
    }

    if (_topics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one topic.')),
      );
      return;
    }

    // Fetch existing syllabus
    final existingSyllabus =
        await _syllabusService.getSyllabus(_selectedStandard);
    List<Topic> existingTopics = [];

    if (existingSyllabus != null) {
      existingTopics = existingSyllabus.topics;
    }

    // Merge existing topics with new topics
    final mergedTopics = List<Topic>.from(existingTopics);

    for (var newTopic in _topics) {
      final index =
          mergedTopics.indexWhere((topic) => topic.title == newTopic.title);
      if (index == -1) {
        mergedTopics.add(newTopic);
      } else {
        mergedTopics[index] = newTopic;
      }
    }

    final syllabus = SyllabusModel(
      standard: _selectedStandard,
      topics: mergedTopics,
    );

    try {
      await _syllabusService.updateSyllabus(syllabus);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save syllabus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Syllabus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Standard',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      ...['1st', '2nd', '3rd', '4th'].map((standard) {
                        return RadioListTile<String>(
                          title: Text(standard,
                              style: const TextStyle(color: Colors.white)),
                          value: standard,
                          groupValue: _selectedStandard,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStandard = value!;
                            });
                          },
                          activeColor: uddeshhyacolor,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Add Topics',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        labelText: 'Topic Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        errorText: _topicError,
                        filled: true,
                        fillColor: Colors.grey[800],
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _addTopic,
                      child: const Text(
                        'Add Topic',
                        style: TextStyle(color: uddeshhyacolor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      final topic = _topics[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            topic.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          // trailing: Checkbox(
                          //   value: topic.isCompleted,
                          //   onChanged: (bool? value) {
                          //     setState(() {
                          //       topic.isCompleted = value!;
                          //     });
                          //   },
                          //   activeColor: uddeshhyacolor,
                          // ),
                          tileColor: Colors.grey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          onLongPress: () {
                            setState(() {
                              _topics.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30.0, left: 24.0, right: 24.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _saveSyllabus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uddeshhyacolor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Syllabus',
                  style: TextStyle(color: textcolor, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
