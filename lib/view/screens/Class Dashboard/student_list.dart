import 'package:flutter/material.dart';

import 'package:uddeshhya/view/constants/theme.dart'; // Ensure this is where `bgcolor` is defined
import 'package:uddeshhya/view/widgets/LiquidProgressIndicator.dart';
import '../../../models/student.dart';
import '../../../services/auth_service.dart';
import '../../../services/student_service.dart';
import 'syllabus_page.dart';

class StudentListScreen extends StatefulWidget {
  final String classId;

  const StudentListScreen({super.key, required this.classId});

  @override
  // ignore: library_private_types_in_public_api
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();
  final AuthService _authService = AuthService();
  // ignore: unused_field
  late Future<List<StudentModel>> _studentsFuture;
  late Future<String> _userRole;
  String _selectedStandard = 'All'; // Default to 'All' to show all students
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentService.getStudents(widget.classId);
    _userRole = _authService.getUserRole(_authService.currentUser!.uid);
  }

  void _addStudent() async {
    final studentData = await _showAddStudentDialog();
    if (studentData.isNotEmpty) {
      final newStudent = StudentModel(
        id: DateTime.now().toString(),
        name: studentData['name']!,
        standard: studentData['standard']!,
        syllabusCompletion: await _studentService
            .fetchSyllabusCompletion(studentData['standard']!),
      );
      await _studentService.addStudent(widget.classId, newStudent);
      setState(() {
        _studentsFuture = _studentService.getStudents(widget.classId);
      });
    }
  }

  Future<Map<String, String?>> _showAddStudentDialog() async {
    final TextEditingController nameController = TextEditingController();
    String? selectedStandard = 'Nursery';

    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.grey[900], // Darker background
              elevation: 8, // Elevated effect
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add New Student',
                    style: TextStyle(
                      color: uddeshhyacolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: textcolor),
                    decoration: InputDecoration(
                      hintText: 'Enter student name',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: uddeshhyacolor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: uddeshhyacolor, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: uddeshhyacolor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // errorText: _nameController.text.isEmpty
                      //     ? 'Name cannot be empty'
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<String>(
                    value: selectedStandard,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStandard = newValue;
                      });
                    },
                    items: <String>[
                      'Nursery',
                      '1st',
                      '2nd',
                      '3rd',
                      '4th',
                      '5th'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.grey[900], // Match dark background
                    iconEnabledColor: uddeshhyacolor, // Icon color
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uddeshhyacolor, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5, // Button shadow
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12), // Padding
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                        color: textcolor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      Navigator.of(context).pop({
                        'name': nameController.text,
                        'standard': selectedStandard,
                      });
                    } else {
                      // Show an error message if the name is empty
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? {}; // Ensure a non-null result is always returned
  }

  Future<List<StudentModel>> _fetchFilteredStudents() async {
    final students = await _studentService.getStudents(widget.classId);
    return students.where((student) {
      final matchesStandard =
          _selectedStandard == 'All' || student.standard == _selectedStandard;
      final matchesSearchQuery =
          student.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStandard && matchesSearchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text(
          'Students',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    style: const TextStyle(color: textcolor),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      prefixIcon:
                          const Icon(Icons.search, color: uddeshhyacolor),
                      hintText: 'Search by name',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: uddeshhyacolor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: uddeshhyacolor, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: uddeshhyacolor.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _selectedStandard,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStandard = newValue!;
                    });
                  },
                  items: <String>[
                    'All',
                    'Nursery',
                    '1st',
                    '2nd',
                    '3rd',
                    '4th',
                    '5th'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  dropdownColor: Colors.grey[900], // Match dark background
                  iconEnabledColor: uddeshhyacolor, // Icon color
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StudentModel>>(
              future: _fetchFilteredStudents(),
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
                        const Icon(Icons.error,
                            color: uddeshhyacolor, size: 50),
                        const SizedBox(height: 16),
                        const Text(
                          'Oops! Something went wrong.',
                          style: TextStyle(
                              color: textcolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.no_accounts_rounded,
                            color: Colors.grey, size: 40),
                        const SizedBox(height: 16),
                        const Text(
                          'No Students Added',
                          style: TextStyle(
                              color: textcolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            'It looks like there are no Students in this class at the moment.',
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
                  );
                }
                final students = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: students.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey[700]), // Subtle separator
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero, // Remove default padding
                      title: Text(
                        student.name,
                        style: const TextStyle(
                          fontSize:
                              18.0, // Slightly smaller font size for a cleaner look
                          fontWeight: FontWeight.bold,
                          color: textcolor, // Light text color
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'Standard: ',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(
                            student.standard,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SyllabusPage(
                        //       student: student,
                        //       classId: widget.classId,
                        //     ),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SyllabusPage(
                              student: student,
                              classId: widget.classId,
                            ), // Replace with your page
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      trailing: FutureBuilder<String>(
                        future: _userRole,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data != 'admin') {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors
                                    .redAccent), // Icon color for visibility
                            onPressed: () async {
                              await _studentService.deleteStudent(
                                  widget.classId, student.id);
                              setState(() {
                                _studentsFuture =
                                    _studentService.getStudents(widget.classId);
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
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
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
            return FloatingActionButton.extended(
              onPressed: _addStudent,
              label: const Text(
                'Add Student',
                style: TextStyle(color: textcolor),
              ),
              icon: const Icon(
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
