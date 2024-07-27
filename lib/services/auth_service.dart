// auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> getCurrentUser() async {
  User? user = _auth.currentUser;
  if (user != null) {
    print('Current user: ${user.email}');
  } else {
    print('No current user found.');
  }
  return user;
}


  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password, String role) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });
      return userCredential.user;
    } catch (e) {
      print('SignUp Error: $e');
      return null;
    }
  }

  Future<String> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['role'] ?? 'team_member';
    }
    return 'team_member'; // Default role
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
