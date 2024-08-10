import 'package:flutter/material.dart';
import '../../../models/syllabus.dart';
import '../../../services/syllabus_service.dart';
import '../../constants/theme.dart';

class AddSyllabusScreen extends StatefulWidget {
  @override
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
      SnackBar(content: Text('Please select a standard.')),
    );
    return;
  }
  
  if (_topics.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please add at least one topic.')),
    );
    return;
  }

  // Fetch existing syllabus
  final existingSyllabus = await _syllabusService.getSyllabus(_selectedStandard);
  List<Topic> existingTopics = [];

  if (existingSyllabus != null) {
    existingTopics = existingSyllabus.topics;
  }

  // Merge existing topics with new topics
  final mergedTopics = List<Topic>.from(existingTopics);

  for (var newTopic in _topics) {
    final index = mergedTopics.indexWhere((topic) => topic.title == newTopic.title);
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
    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save syllabus: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Syllabus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top:16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '     Select Standard',
                    style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('1st', style: TextStyle(color: Colors.white)),
                          value: '1st',
                          groupValue: _selectedStandard,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStandard = value!;
                            });
                          },
                          activeColor: uddeshhyacolor,
                        ),
                        RadioListTile<String>(
                          title: const Text('2nd', style: TextStyle(color: Colors.white)),
                          value: '2nd',
                          groupValue: _selectedStandard,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStandard = value!;
                            });
                          },
                          activeColor: uddeshhyacolor,
                        ),
                        RadioListTile<String>(
                          title: const Text('3rd', style: TextStyle(color: Colors.white)),
                          value: '3rd',
                          groupValue: _selectedStandard,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStandard = value!;
                            });
                          },
                          activeColor: uddeshhyacolor,
                        ),
                        RadioListTile<String>(
                          title: const Text('4th', style: TextStyle(color: Colors.white)),
                          value: '4th',
                          groupValue: _selectedStandard,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStandard = value!;
                            });
                          },
                          activeColor: uddeshhyacolor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '     Add Topics',
                    style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left:24.0, right: 24),
                    child: TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        labelText: 'Topic Name',
                        labelStyle: TextStyle(color: Colors.white70, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent), // You can replace `Colors.blueAccent` with your color
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Increased vertical padding
                        errorText: _topicError,
                        filled: true,
                        fillColor: Colors.transparent, // Background color of the text field
                      ),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white, // Cursor color
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(right:24.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _addTopic,
                        child: const Text('Add Topic', style: TextStyle(color: uddeshhyacolor),),
                        // style: ElevatedButton.styleFrom(
                        //   //primary: uddeshhyacolor,
                        //   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        // ),
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
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            topic.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Checkbox(
                            value: topic.isCompleted,
                            onChanged: (bool? value) {
                              setState(() {
                                topic.isCompleted = value!;
                              });
                            },
                            activeColor: uddeshhyacolor,
                          ),
                          tileColor: Colors.grey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          onLongPress: () {
                            setState(() {
                              _topics.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                    
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:30.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _saveSyllabus,
                child: const Text('Save Syllabus', style: TextStyle(color: textcolor),),
                style: ElevatedButton.styleFrom(
                  primary: uddeshhyacolor,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
