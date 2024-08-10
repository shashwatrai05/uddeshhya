import 'package:flutter/material.dart';

import 'package:uddeshhya/view/constants/theme.dart'; // Ensure this is where `bgcolor` is defined
import 'package:uddeshhya/view/widgets/LiquidProgressIndicator.dart';
import '../../../models/student.dart';
import '../../../services/auth_service.dart';
import '../../../services/student_service.dart';
import 'syllabus_page.dart';

class StudentListScreen extends StatefulWidget {
  final String classId;

  StudentListScreen({required this.classId});

  @override
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
    final TextEditingController _nameController = TextEditingController();
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
                      color: Colors.tealAccent,
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
                    controller: _nameController,
                    style: const TextStyle(color: textcolor),
                    decoration: InputDecoration(
                      hintText: 'Enter student name',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.tealAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.tealAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.tealAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                        child:
                            Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.grey[900], // Match dark background
                    iconEnabledColor: Colors.tealAccent, // Icon color
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
                    primary: Colors.tealAccent, // Button background color
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
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop({
                      'name': _nameController.text,
                      'standard': selectedStandard,
                    });
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.tealAccent),
                      hintText: 'Search by name',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.5)),
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
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  dropdownColor: Colors.grey[900], // Match dark background
                  iconEnabledColor: Colors.tealAccent, // Icon color
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StudentModel>>(
              future:  _fetchFilteredStudents(),
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
                        const Icon(Icons.error, color: uddeshhyacolor, size: 50),
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
                            child: const Text('Go Back'),
                            style: ElevatedButton.styleFrom(
                              primary: uddeshhyacolor, // Background color
                              onPrimary: textcolor, // Text color
                              elevation: 5, // Shadow depth
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
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
                        const Icon(Icons.no_accounts_rounded, color: Colors.grey, size: 40),
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
                            style:
                                TextStyle(color: Colors.grey.shade300, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Go Back'),
                            style: ElevatedButton.styleFrom(
                              primary: uddeshhyacolor, // Background color
                              onPrimary: textcolor, // Text color
                              elevation: 5, // Shadow depth
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12.0), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12), // Padding
                            )),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SyllabusPage(
                              student: student,
                              classId: widget.classId,
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
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data != 'admin') {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent), // Icon color for visibility
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
