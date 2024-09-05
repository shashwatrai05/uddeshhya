import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/screens/allowed_emails.dart';
import 'package:uddeshhya/view/screens/login_screen.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _userRole;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userRole = _authService.getUserRole(user.uid);
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(authService: _authService),
      ),
    ); // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'No email';
    final String name = email.isNotEmpty ? email[0].toUpperCase() : '';

    return Scaffold(
      backgroundColor: bgcolor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<String>(
                future: _userRole,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading Your Role......',
                      style: TextStyle(color: Colors.tealAccent, fontSize: 16),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Role is not determined',
                      style: TextStyle(color: Colors.redAccent),
                    );
                  } else {
                    return Text(
                      'Role: ${snapshot.data ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.tealAccent,
                      ),
                    );
                  }
                },
              ),
              Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 16, right: 16),
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
                  return SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const AllowedEmailsScreen(), // Replace with your page
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            uddeshhyacolor, // Updated background color
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'See All Users',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textcolor),
                      ),
                    ),
                  );
                },
              ),
            ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: uddeshhyacolor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: textcolor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
