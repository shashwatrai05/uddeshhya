// class_management.dart

import 'package:flutter/material.dart';
import '../../models/class.dart';
import '../../models/student.dart';
import '../../services/class_service.dart';
import '../../services/auth_service.dart';
import 'student_list.dart';  // Import the StudentListScreen

class ClassManagementScreen extends StatefulWidget {
  @override
  _ClassManagementScreenState createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final ClassService _classService = ClassService();
  final AuthService _authService = AuthService();
  late Future<List<ClassModel>> _classesFuture;
  late Future<String> _userRole;

  @override
  void initState() {
    super.initState();
    _classesFuture = _classService.getClasses();
    _userRole = _authService.getUserRole(_authService.currentUser!.uid);
  }

  void _addClass() async {
    final className = await _showAddClassDialog();
    if (className != null && className.isNotEmpty) {
      final newClass = ClassModel(
        id: DateTime.now().toString(),
        name: className,
      );
      await _classService.addClass(newClass);
      setState(() {
        _classesFuture = _classService.getClasses();
      });
    }
  }

  Future<String?> _showAddClassDialog() {
    final TextEditingController _nameController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Class'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter class name'),
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

  void _showStudents(String classId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListScreen(classId: classId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Management'),
        actions: <Widget>[
          FutureBuilder<String>(
            future: _userRole,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
                return SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.add),
                onPressed: _addClass,
              );
            },
          ),
         
        ],
      ),
      body: FutureBuilder<List<ClassModel>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No classes available.'));
          }
          final classes = snapshot.data!;
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              return ListTile(
                title: Text(classModel.name),
                subtitle: FutureBuilder<List<StudentModel>>(
                  future: _classService.getStudents(classModel.id),
                  builder: (context, studentSnapshot) {
                    if (studentSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (studentSnapshot.hasError) {
                      return const Text('Error loading students');
                    }
                    if (!studentSnapshot.hasData || studentSnapshot.data!.isEmpty) {
                      return const Text('No students');
                    }
                    final students = studentSnapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: students.map((student) => Text(student.name)).toList(),
                    );
                  },
                ),
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
                        await _classService.deleteClass(classModel.id);
                        setState(() {
                          _classesFuture = _classService.getClasses();
                        });
                      },
                    );
                  },
                ),
                onTap: () => _showStudents(classModel.id),
              );
            },
          );
        },
      ),
    );
  }
}
