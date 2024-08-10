import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/add_syllabus.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/attendance_class_List.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/attendance_history.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/attendance_screen.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/class_management.dart';

import '../../../services/auth_service.dart';
import '../../widgets/header.dart';

class HomeScreen extends StatefulWidget {
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
            SizedBox(height: 20,),
            // Hero Sectio
            Header(title: 'DASHBOARD OVERVIEW', subtitle: 'Manage students, track attendance, and plan activities.',),
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
                        MaterialPageRoute(
                          builder: (context) => ClassManagementScreen(),
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
                        MaterialPageRoute(
                          builder: (context) => AttendanceScreen(),
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
                        MaterialPageRoute(
                          builder: (context) => AttendanceClassListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
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
                  return DashboardCard(
                      title: 'Add Syllabus',
                      subtitle: 'Add or modify course syllabus',
                      icon: FontAwesomeIcons.book,
                      color: Colors.purpleAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSyllabusScreen(),
                          ),
                        );
                      },
                    );
                    }
                  ),
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

  DashboardCard({
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
                  color: textcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle,
              style: const TextStyle(color: Colors.white60, fontSize: 14)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: color),
          onTap: onTap,
        ),
    );
  }
}
