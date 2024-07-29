// import 'package:flutter/material.dart';
// import '../models/class_model.dart';
// import '../services/class_service.dart';
// import '../services/auth_service.dart';
// import 'student_list_screen.dart';
// import 'attendance_screen.dart';  // Import the AttendanceScreen

// class ClassManagementScreen extends StatefulWidget {
//   @override
//   _ClassManagementScreenState createState() => _ClassManagementScreenState();
// }

// class _ClassManagementScreenState extends State<ClassManagementScreen> {
//   final ClassService _classService = ClassService();
//   final AuthService _authService = AuthService();
//   late Future<List<ClassModel>> _classesFuture;
//   late Future<String> _userRole;

//   @override
//   void initState() {
//     super.initState();
//     _classesFuture = _classService.getClasses();
//     _userRole = _authService.getUserRole(_authService.currentUser!.uid);
//   }

//   void _addClass() async {
//     final className = await _showAddClassDialog();
//     if (className != null && className.isNotEmpty) {
//       final newClass = ClassModel(
//         id: DateTime.now().toString(),
//         name: className,
//       );
//       await _classService.addClass(newClass);
//       setState(() {
//         _classesFuture = _classService.getClasses();
//       });
//     }
//   }

//   Future<String?> _showAddClassDialog() {
//     final TextEditingController _nameController = TextEditingController();
//     return showDialog<String>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Add New Class'),
//           content: TextField(
//             controller: _nameController,
//             decoration: InputDecoration(hintText: 'Enter class name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 Navigator.of(context).pop(_nameController.text);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showStudents(String classId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StudentListScreen(classId: classId),
//       ),
//     );
//   }

//   void _navigateToAttendance(String classId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AttendanceScreen(
//           classId: classId,
//           date: DateTime.now(), // Default to today’s date
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Class Management'),
//         actions: <Widget>[
//           FutureBuilder<String>(
//             future: _userRole,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
//                 return SizedBox.shrink();
//               }
//               return IconButton(
//                 icon: Icon(Icons.add),
//                 onPressed: _addClass,
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<ClassModel>>(
//         future: _classesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No classes available.'));
//           }
//           final classes = snapshot.data!;
//           return ListView.builder(
//             itemCount: classes.length,
//             itemBuilder: (context, index) {
//               final classModel = classes[index];
//               return ListTile(
//                 title: Text(classModel.name),
//                 subtitle: FutureBuilder<List<StudentModel>>(
//                   future: _classService.getStudents(classModel.id),
//                   builder: (context, studentSnapshot) {
//                     if (studentSnapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     }
//                     if (studentSnapshot.hasError) {
//                       return Text('Error loading students');
//                     }
//                     if (!studentSnapshot.hasData || studentSnapshot.data!.isEmpty) {
//                       return Text('No students');
//                     }
//                     final students = studentSnapshot.data!;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: students.map((student) => Text(student.name)).toList(),
//                     );
//                   },
//                 ),
//                 trailing: FutureBuilder<String>(
//                   future: _userRole,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return SizedBox.shrink();
//                     }
//                     if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
//                       return SizedBox.shrink();
//                     }
//                     return IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () async {
//                         await _classService.deleteClass(classModel.id);
//                         setState(() {
//                           _classesFuture = _classService.getClasses();
//                         });
//                       },
//                     );
//                   },
//                 ),
//                 onTap: () => _navigateToAttendance(classModel.id),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
