import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/models/syllabus.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import '../../../models/student.dart';

class SyllabusPage extends StatefulWidget {
  final StudentModel student;
  final String classId;

  const SyllabusPage({super.key, required this.student, required this.classId});

  @override
  _SyllabusPageState createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Topic> _orderedTopics = [];
  Map<String, bool> _completionStatus = {};

  @override
  void initState() {
    super.initState();
    _loadOrderedSyllabus();
  }

  Future<void> _loadOrderedSyllabus() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });

      // Get the syllabus document for the student's standard
      final syllabusDoc = await FirebaseFirestore.instance
          .collection('syllabus')
          .doc(widget.student.standard)
          .get();

      if (!syllabusDoc.exists) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No syllabus found for this standard';
        });
        return;
      }

      // Parse the topics data
      final topicsData = syllabusDoc.data()?['topics'] as List<dynamic>?;
      if (topicsData == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Invalid syllabus data structure';
        });
        return;
      }

      // Convert to Topic objects and sort by order
      final topics = topicsData
          .map((t) => Topic.fromMap(t as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      // Create completion status map using student's existing data
      final completionStatus = Map<String, bool>.from(
          widget.student.syllabusCompletion);

      setState(() {
        _orderedTopics = topics;
        _completionStatus = completionStatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load syllabus: $e';
      });
    }
  }

  Future<void> _submitSyllabus() async {
    try {
      setState(() => _isLoading = true);

      // Create updated completion map
      final updatedCompletion = Map<String, bool>.fromIterable(
        _orderedTopics,
        key: (topic) => (topic as Topic).title,
        value: (topic) => _completionStatus[(topic as Topic).title] ?? false,
      );

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('students')
          .doc(widget.student.id)
          .update({'syllabusCompletion': updatedCompletion});

      setState(() => _isLoading = false);

      // Show success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syllabus progress updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to update syllabus: $e';
      });

      // Show error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update syllabus: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: uddeshhyacolor,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadOrderedSyllabus,
            style: ElevatedButton.styleFrom(
              backgroundColor: uddeshhyacolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: textcolor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Topics Available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No syllabus topics have been added yet.',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsList() {
    return ListView.builder(
      itemCount: _orderedTopics.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final topic = _orderedTopics[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[700]!,
              width: 1,
            ),
          ),
          child: CheckboxListTile(
            title: Text(
              topic.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Topic ${index + 1}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            value: _completionStatus[topic.title] ?? false,
            onChanged: (bool? value) {
              setState(() {
                _completionStatus[topic.title] = value ?? false;
              });
            },
            activeColor: uddeshhyacolor,
            checkColor: Colors.black,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        );
      },
    );
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
            child: RefreshIndicator(
              onRefresh: _loadOrderedSyllabus,
              color: uddeshhyacolor,
              child: _isLoading
                  ? _buildLoadingState()
                  : _hasError
                      ? _buildErrorState()
                      : _orderedTopics.isEmpty
                          ? _buildEmptyState()
                          : _buildTopicsList(),
            ),
          ),
          if (!_isLoading && !_hasError && _orderedTopics.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitSyllabus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uddeshhyacolor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Progress',
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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