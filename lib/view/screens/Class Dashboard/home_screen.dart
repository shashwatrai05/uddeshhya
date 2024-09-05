import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/add_syllabus.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/attendance_class_list.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/attendance_screen.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/class_management.dart';

import '../../../services/auth_service.dart';
import '../../widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _userRole = _authService.getUserRole(_authService.currentUser!.uid);
  }

  late Future<String> _userRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Hero Sectio
            const Header(
              title: 'DASHBOARD OVERVIEW',
              subtitle:
                  'Manage students, track attendance, and plan activities.',
            ),
            const SizedBox(height: 20),
            // Dashboard Cards
            Expanded(
              child: ListView(
                children: [
                  DashboardCard(
                    title: 'Explore Classes',
                    subtitle: 'Browse and manage all classes',
                    icon: Icons.school,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              const ClassManagementScreen(), // Replace with your page
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                  ),
                  const SizedBox(height: 16),
                  DashboardCard(
                    title: 'Record Attendance',
                    subtitle: 'Mark student attendance quickly',
                    icon: Icons.check_circle,
                    color: Colors.greenAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              const AttendanceScreen(), // Replace with your page
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                  ),
                  const SizedBox(height: 16),
                  DashboardCard(
                    title: 'Attendance History',
                    subtitle: 'Review past attendance records',
                    icon: Icons.history,
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              const AttendanceClassListScreen(), // Replace with your page
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
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
                        return DashboardCard(
                          title: 'Add Syllabus',
                          subtitle: 'Add or modify course syllabus',
                          icon: FontAwesomeIcons.book,
                          color: Colors.purpleAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const AddSyllabusScreen(), // Replace with your page
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
                        );
                      }),
                      const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title,
            style: const TextStyle(
                color: textcolor, fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 14)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: color),
        onTap: onTap,
      ),
    );
  }
}
