import 'package:flutter/material.dart';
import '../../../models/class.dart';
import '../../../models/student.dart';
import '../../../services/class_service.dart';
import '../../../services/attendance_service.dart';
import '../../../services/student_service.dart';
import '../../constants/theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final ClassService _classService = ClassService();
  final StudentService _studentService = StudentService();
  final AttendanceService _attendanceService = AttendanceService();

  List<ClassModel> _classes = [];
  List<StudentModel> _students = [];
  Map<String, bool> _attendance = {}; // Key is now studentName
  String? _selectedClassId; // This will store the ID for selection
  String? _selectedClassName; // This will store the name for display
  DateTime _selectedDate = DateTime.now();

  // Create a map to link ids to names
  Map<String, String> _idToNameMap = {};

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await _classService.getClasses();
    setState(() {
      _classes = classes;
      // ignore: prefer_for_elements_to_map_fromiterable
      _idToNameMap = Map.fromIterable(
        classes,
        key: (classModel) => classModel.id,
        value: (classModel) => classModel.name,
      );
    });
  }

  Future<void> _loadStudents() async {
    if (_selectedClassId != null) {
      final students = await _studentService.getStudents(_selectedClassId!);
      setState(() {
        _students = students;
        _attendance = {
          for (var student in students) student.name: false
        }; // Use student.name as key
      });
    }
  }

  void _submitAttendance() async {
    if (_selectedClassId != null) {
      final attendanceData = Map<String, bool>.from(_attendance);

      await _attendanceService.submitAttendance(
        _selectedClassName!,
        _selectedDate,
        attendanceData,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take Attendance',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Class Dropdown
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[850], // Darker background
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.grey.shade500),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedClassId,
                  hint: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Adequate horizontal padding
                    child: Text(
                      'Select Class',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  icon: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0), // Reduced spacing
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 30,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  dropdownColor:
                      Colors.grey[900], // Dark background for dropdown menu
                  onChanged: (value) {
                    setState(() {
                      _selectedClassId = value;
                      _selectedClassName = _idToNameMap[value!];
                      _loadStudents();
                    });
                  },
                  items: _classes.map((classModel) {
                    return DropdownMenuItem<String>(
                      value: classModel.id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Padding for items
                        child: Text(
                          classModel.name,
                          style: const TextStyle(color: textcolor),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Date Picker
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[850], // Darker background
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.grey.shade500),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                style: const TextStyle(color: textcolor),
                readOnly: true,
                controller: TextEditingController(
                    text: '${_selectedDate.toLocal()}'.split(' ')[0]),
                onTap: () async {
                  final date = await showDatePicker(
                    //barrierColor: Colors.grey[900],
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          primaryColor:
                              Colors.blueAccent, // Color of the selected date
                          //accentColor: Colors.teal,  // Color of the date picker header
                          buttonTheme: const ButtonThemeData(
                            textTheme:
                                ButtonTextTheme.primary, // Color of the buttons
                          ),
                          dialogBackgroundColor: Colors
                              .black, // Background color of the date picker
                          dividerColor: uddeshhyacolor, // Color of the divider
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  uddeshhyacolor, // Color of the text buttons
                            ),
                          ),
                          // Optional: Adjust colors for other elements if needed
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null && date != _selectedDate) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            // Student List
            Expanded(
              child: ListView(
                children: _students.map((student) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),

                    //color: Colors.grey[800],
                    child: CheckboxListTile(
                      title: Text(
                        student.name,
                        style: const TextStyle(color: textcolor),
                      ),
                      value: _attendance[student.name],
                      onChanged: (value) {
                        setState(() {
                          _attendance[student.name] = value ?? false;
                        });
                      },
                      activeColor: uddeshhyacolor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Submit Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _submitAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uddeshhyacolor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    'Submit Attendance',
                    style: TextStyle(color: textcolor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
