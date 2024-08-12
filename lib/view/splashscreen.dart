import 'package:flutter/material.dart';

import '../services/auth_service.dart';// Import your AuthService

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = _authService.currentUser;
    if (user != null) {
      // User is signed in, navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not signed in, navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
