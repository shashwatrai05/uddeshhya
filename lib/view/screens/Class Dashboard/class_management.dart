import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uddeshhya/view/constants/theme.dart'; // Ensure this is where `bgcolor` is defined
import 'package:uddeshhya/view/widgets/LiquidProgressIndicator.dart';
import '../../../models/class.dart';
import '../../../models/student.dart';
import '../../../services/class_service.dart';
import '../../../services/auth_service.dart';
import 'student_list.dart'; // Import the StudentListScreen

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.grey[900], // Dark background color
        elevation: 8, // Enhanced shadow effect
        title:
            Text(
              'Add New Class',
              style: TextStyle(
                color:Colors.tealAccent, // Primary color
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(color: textcolor), // Light text color
            decoration: InputDecoration(
              hintText: 'Enter class name',
              hintStyle: TextStyle(color: Colors.grey[500]), // Subtle hint color
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.tealAccent, // Button text color
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // Rounded button
              ),
              elevation: 5, // Button shadow
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
            ),
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
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text(
          'Class Management',
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
      body: FutureBuilder<List<ClassModel>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LiquidProgressIndicator(value: 50, maxValue: 100));
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: uddeshhyacolor, size: 50),
                  SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        primary: uddeshhyacolor, // Background color
                        onPrimary: textcolor, // Text color
                        elevation: 5, // Shadow depth
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Padding
                      )),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_meeting_room_rounded, color: Colors.grey, size: 40),
                  SizedBox(height: 16),
                  Text(
                    'No Classes Available',
                    style: TextStyle(
                        color: textcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'It looks like there are no classes available at the moment.',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                        primary: uddeshhyacolor, // Background color
                        onPrimary: textcolor, // Text color
                        elevation: 5, // Shadow depth
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Padding
                      )
                  ),
                ],
              ),
            );
}

          final classes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              return Card(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                color: Colors.grey[850],
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  //contentPadding: const EdgeInsets.all(2.0),
                  leading: Icon(Icons.group, color: textcolor),
                  title: Text(
                    classModel.name,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: textcolor),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top:3.0),
                    child: FutureBuilder<List<StudentModel>>(
                      future: _classService.getStudents(classModel.id),
                      builder: (context, studentSnapshot) {
                        if (studentSnapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading Students....', style: const TextStyle(color: Colors.white60, fontSize: 14),);
                        }
                        if (studentSnapshot.hasError) {
                          return Text('Unable to load students', style: const TextStyle(color: Colors.white60, fontSize: 14));
                        }
                        if (!studentSnapshot.hasData || studentSnapshot.data!.isEmpty) {
                          return Text('No students',style: const TextStyle(color: Colors.white60, fontSize: 14));
                        }
                    
                        final students = studentSnapshot.data!;
                        final studentCount = students.length; // Get the length of the student list
                    
                        return
                            Text('Total Students: $studentCount', style: const TextStyle(color: Colors.white60, fontSize: 14));// Display the student count
                            //...students.map((student) => Text(student.name)).toList(),
                      },
                    ),
                  ),

                  trailing: FutureBuilder<String>(
                    future: _userRole,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data != 'admin') {
                        return const SizedBox.shrink();
                      }
                      return IconButton(
                        icon: const Icon(Icons.delete, color: uddeshhyacolor),
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
          future: _userRole,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data != 'admin') {
              return SizedBox.shrink();
            }
            return FloatingActionButton.extended(
              onPressed: _addClass,
              label: Text(
                'Add Class',
                style: TextStyle(color: textcolor),
              ),
              icon: Icon(
                Icons.add,
                color: textcolor,
              ),
              backgroundColor: uddeshhyacolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
