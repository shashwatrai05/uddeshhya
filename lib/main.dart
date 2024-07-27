import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uddeshhya/mainScreen.dart';
import 'package:uddeshhya/services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
       options: const FirebaseOptions(
    apiKey: 'AIzaSyCddQrr5NMlp9oT9BJb16CFOI8T8p40AAY',
    appId: '1:431244686112:android:2de3225c55185acc051d45',
    messagingSenderId: '431244686112',
    projectId: 'uddeshhya-fe2ef',
    storageBucket: 'gs://uddeshhya-fe2ef.appspot.com',
  )
    );
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  
  runApp(MyApp());
}


// class MyApp extends StatelessWidget {
//   final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(authService: _auth),
//       routes: {
//         SignUpScreen.routeName: (context) => SignUpScreen(authService: _auth),
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<User?>(
        future: _auth.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data!.email}');
            return const MainPage(); // User is already logged in
          } else {
            print('No user logged in');
            return LoginScreen(authService: _auth); // User is not logged in
          }
        },
      ),
      routes: {
        SignUpScreen.routeName: (context) => SignUpScreen(authService: _auth),
      },
    );
  }
}
