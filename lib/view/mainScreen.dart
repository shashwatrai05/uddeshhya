import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/screens/activity_planner_screen.dart';
import 'package:uddeshhya/view/screens/Class%20Dashboard/home_screen.dart';
import 'package:uddeshhya/view/screens/expense_page.dart';
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
      HomeScreen(),
      //ClassManagementScreen(),
      ActivityPlannerScreen(), // Replace with your actual placeholder widget or screen
      //AttendanceHistoryScreen(),
      
      //ActivityPlannerScreen()
      ExpensesPage(),
      ProfilePage(),
      // Add more screens here
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: kblackcolor,
      //backgroundColor: Colors.transparent,
   appBar: AppBar(
  title: const Text(
    'UDDESHHYA',
    style: TextStyle(
      fontWeight: FontWeight.w700,
      color: textcolor,
    ),
  ),
  //elevation: 15,
  backgroundColor: Colors.transparent,
  leading: Padding(
    padding: const EdgeInsets.only(left: 16.0),
    // ignore: sized_box_for_whitespace
    child: Container(
      height: 10,  // Adjust this value to control the height of the container
      child: Image.asset(
        'assets/logo.png',
        height: 10,  // Adjust this value to control the height of the image
        width: 10,   // Optionally adjust this value to control the width of the image
      ),
    ),
  ),
),

      body: tabWidgets!.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: uddeshhyacolor,
        items: const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 25, color: Colors.white),
              Text('Class', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Icon(Icons.info, size: 25, color: Colors.white),
          //     Text('Attendance',
          //         style: TextStyle(color: Colors.white, fontSize: 12)),
          //   ],
          // ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_activity_rounded,
                  size: 25, color: Colors.white),
              Text('Activities', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),

            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.currency_rupee_rounded,
                  size: 25, color: Colors.white),
              Text('Expenses', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_2_rounded,
                  size: 25, color: Colors.white),
              Text('Profile', style: TextStyle(color: Colors.white, fontSize: 12)),
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
        color: Colors.black.withOpacity(0.95),
        buttonBackgroundColor: Colors.transparent,
      ),
    );
  }
}
