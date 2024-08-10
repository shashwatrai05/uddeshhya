import 'package:flutter/material.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/mainScreen.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart'; // Import the login screen

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  final AuthService authService;

  // ignore: prefer_const_constructors_in_immutables
  SignUpScreen({required this.authService});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String role = 'team_member'; // Default role
  bool _obscureText = true; // Toggle for password visibility
  // ignore: unused_field
  String? _errorMessage;

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email and password cannot be empty');
      return;
    }

    // Email validation
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(email)) {
      _showSnackBar('Enter a valid email address');
      return;
    }

    // Password validation
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long');
      return;
    }

    try {
      final newUser = await widget.authService.signUpWithEmailAndPassword(email, password, role);
      if (newUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Registration failed. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: uddeshhyacolor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 20, right: 20, bottom: 30),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hey there,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textcolor,
                    ),
                  ),
                  Text(
                    'Welcome to Uddeshyay',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: uddeshhyacolor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
              
              Center(
                child: Text(
                  'Create Your Account',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 30,),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white60),
                  labelStyle: const TextStyle(color: Colors.white70),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blueGrey[500]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  hintStyle: const TextStyle(color: Colors.white60),
                  labelStyle: const TextStyle(color: Colors.white70),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blueGrey[500]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20.0),
            
              const SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      primary: uddeshhyacolor,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, color: textcolor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.25),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
