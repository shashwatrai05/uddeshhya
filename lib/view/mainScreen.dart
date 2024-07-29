import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/view/screens/activity_planner_screen.dart';
import 'package:uddeshhya/view/screens/attendance_history.dart';
import 'package:uddeshhya/view/screens/attendance_screen.dart';
import 'package:uddeshhya/view/screens/class_management.dart';
import 'package:uddeshhya/view/screens/profilepage.dart';

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
      ProfilePage(),
      ActivityPlannerScreen()
      // Add more screens here
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Class Management'),
      //   actions: <Widget>[
      //     FutureBuilder<String>(
      //       future: _userRole,
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(child: CircularProgressIndicator());
      //         }
      //         if (snapshot.hasError || !snapshot.hasData || snapshot.data != 'admin') {
      //           return SizedBox.shrink();
      //         }
      //         return IconButton(
      //           icon: Icon(Icons.add),
      //           onPressed: _addClass,
      //         );
      //       },
      //     ),
      //     IconButton(onPressed: (){
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AttendanceScreen(),
      //         ),
      //       );
      //     } , icon: Icon(Icons.abc)),
      //     IconButton(onPressed: (){
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AttendanceHistoryScreen(),
      //         ),
      //       );
      //     } , icon: Icon(Icons.abc))
      //   ],
      // ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book,
                  size: 25, color: Colors.white),
              Text('Syllabus', style: TextStyle(color: Colors.white, fontSize: 12)),
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
