import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/screens/attendance_history.dart';
import 'package:uddeshhya/screens/attendance_screen.dart';
import 'package:uddeshhya/screens/class_management.dart';
import 'package:uddeshhya/screens/profilepage.dart';

class MainPage extends StatefulWidget {
  final int selectedIndex;

  const MainPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  static List<Widget>? tabWidgets;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    tabWidgets = <Widget>[
      ClassManagementScreen(),
      AttendanceScreen(), // Replace with your actual placeholder widget or screen
      AttendanceHistoryScreen(),
      ProfilePage()
      // Add more screens here
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'E-CELL KIET',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.transparent,
       
      ),
      body: tabWidgets!.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        //backgroundColor: ecellcolor,
        items: const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 25, color: Colors.white),
              Text('Class', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 25, color: Colors.white),
              Text('Attendance',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.miscellaneous_services_rounded,
                  size: 25, color: Colors.white),
              Text('History', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),

            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,
                  size: 25, color: Colors.white),
              Text('History', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ],
        index: _selectedIndex,
        onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          
        },
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        color: Colors.black.withOpacity(0.8),
        buttonBackgroundColor: Colors.transparent,
      ),
    );
  }
}
