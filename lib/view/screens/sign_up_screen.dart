import 'package:flutter/material.dart';
import 'package:uddeshhya/view/screens/class_management.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  final AuthService authService;

  SignUpScreen({required this.authService});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String email;
  late String password;
  String role = 'team_member'; // Default role

  void _register() async {
    final newUser = await widget.authService.signUpWithEmailAndPassword(email, password, role);
    if (newUser != null) {
       Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassManagementScreen(),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            DropdownButton<String>(
              value: role,
              onChanged: (String? newValue) {
                setState(() {
                  role = newValue!;
                });
              },
              items: <String>['admin', 'team_member']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
