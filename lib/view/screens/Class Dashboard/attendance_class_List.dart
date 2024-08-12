import 'package:flutter/material.dart';
import 'package:uddeshhya/view/widgets/LiquidProgressIndicator.dart';
import '../../../models/class.dart';
import '../../../services/class_service.dart';
import '../../constants/theme.dart';
import 'attendance_history.dart';

class AttendanceClassListScreen extends StatefulWidget {
  const AttendanceClassListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceClassListScreenState createState() =>
      _AttendanceClassListScreenState();
}

class _AttendanceClassListScreenState extends State<AttendanceClassListScreen> {
  final ClassService _classService = ClassService();
  List<ClassModel> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _classService.getClasses();
      setState(() {
        _classes = classes;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error (e.g., show a Snackbar or an error message)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Record',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: _isLoading
          ? Center(child: LiquidProgressIndicator(value: 50, maxValue: 100))
          : _classes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.no_meeting_room_rounded,
                          color: Colors.grey, size: 40),
                      const SizedBox(height: 16),
                      const Text(
                        'No Classes Available',
                        style: TextStyle(
                            color: textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'It looks like there are no classes available at the moment.',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 14),
                        textAlign: TextAlign.center,
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
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    final classModel = _classes[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        title: Text(
                          classModel.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: textcolor),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AttendanceHistoryScreen(
                                          className: classModel
                                              .name), // Replace with your page
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
                        tileColor: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
