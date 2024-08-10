import 'package:flutter/material.dart';
import 'package:uddeshhya/view/constants/theme.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const Header({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height*0.17,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [uddeshhyacolor, kUpperContainerColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              //'Dashboard Overview',
              style: TextStyle(
                color: textcolor,
                fontSize: MediaQuery.of(context).size.width*0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            //Uncomment and update this text if needed
            Text(
              subtitle,
              //'Manage students, track attendance, and plan activities.',
              style: TextStyle(
                color: Colors.white70, 
                fontSize: MediaQuery.of(context).size.width*0.04,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
