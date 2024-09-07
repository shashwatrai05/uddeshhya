import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/theme.dart';

class AllowedEmailsScreen extends StatefulWidget {
  const AllowedEmailsScreen({super.key});

  @override
  _AllowedEmailsScreenState createState() => _AllowedEmailsScreenState();
}

class _AllowedEmailsScreenState extends State<AllowedEmailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  List<String> _emails = [];
  // ignore: unused_field
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _fetchEmails();
  }

  Future<void> _fetchEmails() async {
    try {
      final querySnapshot = await _firestore.collection('allowed_emails').get();
      setState(() {
        _emails = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _addEmail() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await _firestore.collection('allowed_emails').doc(email).set({});
        _emailController.clear();
        await _fetchEmails();
      } catch (e) {
        // Handle error
      }
    } else {
      setState(() {
        _emailError = 'Email cannot be empty';
      });
    }
  }

  Future<void> _removeEmail(String email) async {
    try {
      await _firestore.collection('allowed_emails').doc(email).delete();
      await _fetchEmails();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _editEmail(String oldEmail, String newEmail) async {
    if (newEmail.isNotEmpty) {
      try {
        await _firestore.collection('allowed_emails').doc(oldEmail).delete();
        await _firestore.collection('allowed_emails').doc(newEmail).set({});
        await _fetchEmails();
      } catch (e) {
        // Handle error
      }
    }
  }

  void _showEditDialog(String oldEmail) {
    final TextEditingController _newEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:kUpperContainerColor,
          title: const Text('Edit Email', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _newEmailController,
             style: const TextStyle(color: textcolor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: uddeshhyacolor),
                  hintText: 'Write new email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: uddeshhyacolor, width: 1.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Adjust vertical padding
                ),
            cursorColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _emailError = null;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: textcolor)),
            ),
            TextButton(
              onPressed: () {
                _editEmail(oldEmail, _newEmailController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: uddeshhyacolor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allowed Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                     style: const TextStyle(color: textcolor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: uddeshhyacolor),
                  hintText: 'Add a User',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: uddeshhyacolor, width: 1.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Adjust vertical padding
                ),
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _emailError = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addEmail,
                  style: ElevatedButton.styleFrom(
                    primary: uddeshhyacolor,
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add', style: TextStyle(color: textcolor),),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _emails.length,
              itemBuilder: (context, index) {
                final email = _emails[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      email,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _showEditDialog(email),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[900],
                                  title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
                                  content: Text(
                                    'Are you sure you want to delete $email?',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel', style: TextStyle(color: Colors.blueAccent)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _removeEmail(email);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
