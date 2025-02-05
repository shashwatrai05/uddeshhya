import 'package:flutter/material.dart';
import '../../../models/syllabus.dart';
import '../../../services/syllabus_service.dart';
import '../../constants/theme.dart';

class AddSyllabusScreen extends StatefulWidget {
  const AddSyllabusScreen({super.key});

  @override
  _AddSyllabusScreenState createState() => _AddSyllabusScreenState();
}

class _AddSyllabusScreenState extends State<AddSyllabusScreen> {
  final SyllabusService _syllabusService = SyllabusService();
  final TextEditingController _topicController = TextEditingController();
  final List<Topic> _topics = [];
  String _selectedStandard = 'Nursery';
  String? _topicError;
  bool _isOtherSelected = false;
  final TextEditingController _otherStandardController = TextEditingController();
  String? _lastLoadedStandard; // Track which standard's syllabus was last loaded

  Future<void> _loadExistingSyllabus(String standard) async {
    // Only load if we haven't already loaded this standard's syllabus
    if (_lastLoadedStandard != standard) {
      setState(() {
        _topics.clear(); // Clear previous topics
      });

      final existingSyllabus = await _syllabusService.getSyllabus(standard);
      if (existingSyllabus != null) {
        setState(() {
          _topics.addAll(existingSyllabus.topics);
          _lastLoadedStandard = standard; // Update the last loaded standard
        });
      } else {
        // If no existing syllabus, just update the last loaded standard
        _lastLoadedStandard = standard;
      }
    }
  }

  void _addTopic() {
    final topicTitle = _topicController.text.trim();
    if (topicTitle.isNotEmpty) {
      setState(() {
        _topics.add(Topic(
          title: topicTitle,
          order: _topics.length,
          isCompleted: false,
        ));
        _topicController.clear();
        _topicError = null;
      });
    } else {
      setState(() {
        _topicError = 'Topic cannot be empty';
      });
    }
  }

  void _removeTopic(Topic topic) {
    setState(() {
      _topics.remove(topic);
      // Reorder remaining topics
      for (var i = 0; i < _topics.length; i++) {
        _topics[i] = Topic(
          title: _topics[i].title,
          order: i,
          isCompleted: _topics[i].isCompleted,
        );
      }
    });
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

    final syllabus = SyllabusModel(
      standard: _selectedStandard,
      topics: List<Topic>.from(_topics),
    );

    try {
      await _syllabusService.updateSyllabus(syllabus);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syllabus saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save syllabus: $e'),
          backgroundColor: Colors.red,
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Select Standard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.0),
                        ),
                        child: DropdownButton<String>(
                          value: _isOtherSelected ? 'Other' : _selectedStandard,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          dropdownColor: Colors.grey[850],
                          underline: const SizedBox(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          items: [
                            'Nursery', 'LKG', 'UKG', '1st', '2nd', '3rd', '4th',
                            '5th', '6th', '7th', '8th', '9th', '10th', '11th',
                            '12th', 'Other'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              if (value == 'Other') {
                                _isOtherSelected = true;
                                _selectedStandard = '';
                                _topics.clear();
                                _lastLoadedStandard = null;
                              } else {
                                _isOtherSelected = false;
                                _selectedStandard = value!;
                                _loadExistingSyllabus(_selectedStandard);
                              }
                            });
                          },
                        ),
                      ),
                      if (_isOtherSelected)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: TextField(
                            controller: _otherStandardController,
                            decoration: InputDecoration(
                              labelText: 'Enter Custom Class',
                              labelStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white54),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.blueAccent),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            onChanged: (text) {
                              setState(() {
                                _selectedStandard = text;
                                _topics.clear();
                                _lastLoadedStandard = null;
                              });
                            },
                          ),
                        ),
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
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
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
                  Column(
                    children: _topics.map((topic) {
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
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[300]),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: kUpperContainerColor,
                                    title: const Text(
                                      'Confirm Deletion',
                                      style: TextStyle(color: textcolor),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete this topic?',
                                      style: TextStyle(
                                        color: textcolor.withOpacity(0.8),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: textcolor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _removeTopic(topic);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: uddeshhyacolor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          tileColor: Colors.grey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, left: 24.0, right: 24.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _saveSyllabus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uddeshhyacolor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 24.0,
                  ),
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