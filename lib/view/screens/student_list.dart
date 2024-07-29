import 'package:flutter/material.dart';
import 'package:uddeshhya/view/screens/syllabus_page.dart';
import '../../models/student.dart';
import '../../services/auth_service.dart';
import '../../services/student_service.dart'; // Import the StudentService

class StudentListScreen extends StatefulWidget {
  final String classId;

  StudentListScreen({required this.classId});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();
  final AuthService _authService = AuthService();
  late Future<List<StudentModel>> _studentsFuture;
  late Future<String> _userRole;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentService.getStudents(widget.classId);
    _userRole = _authService.getUserRole(_authService.currentUser!.uid);
  }

  void _addStudent() async {
    final studentName = await _showAddStudentDialog();
    final studentStandard = await _showStandardDialog();
    if (studentName != null && studentName.isNotEmpty && studentStandard != null) {
      final syllabusCompletion = await _studentService.fetchSyllabusCompletion(studentStandard);
      final newStudent = StudentModel(
        id: DateTime.now().toString(),
        name: studentName,
        standard: studentStandard,
        syllabusCompletion: syllabusCompletion,
      );
      await _studentService.addStudent(widget.classId, newStudent);
      setState(() {
        _studentsFuture = _studentService.getStudents(widget.classId);
      });
    }
  }

  Future<String?> _showStandardDialog() {
    final TextEditingController _standardController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Student Standard'),
          content: TextField(
            controller: _standardController,
            decoration: const InputDecoration(hintText: 'Enter student standard'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(_standardController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showAddStudentDialog() {
    final TextEditingController _nameController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter student name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(_nameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: <Widget>[
          FutureBuilder<String>(
            future: _userRole,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addStudent,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<StudentModel>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students available.'));
          }
          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student.name),
                onTap: () {
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SyllabusPage(
      student: student,
      classId: widget.classId, // Pass the classId here
    ),
  ),
);

                },
                trailing: FutureBuilder<String>(
                  future: _userRole,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _studentService.deleteStudent(widget.classId, student.id);
                        setState(() {
                          _studentsFuture = _studentService.getStudents(widget.classId);
                        });
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
