import 'package:flutter/material.dart';
import 'package:uddeshhya/services/expense_service.dart';
import 'package:uddeshhya/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/widgets/header.dart';
import '../../services/auth_service.dart';
import 'admin_expense_page.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ExpenseService _expenseService = ExpenseService();
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<ExpenseModel> _expenses = [];
  bool _isLoading = true;

  late Future<String> _userRole;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _userRole =
        _authService.getUserRole(FirebaseAuth.instance.currentUser!.uid);
  }

  void _loadExpenses() async {
    try {
      final String email =
          FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
      final expenses = await _expenseService.getUserExpenses(email);
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      // Log the error
      // print('Error loading expenses: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load expenses')),
      );
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blueAccent, // Color of the selected date
            //accentColor: Colors.teal,  // Color of the date picker header
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Color of the buttons
            ),
            dialogBackgroundColor:
                Colors.black, // Background color of the date picker
            dividerColor: Colors.teal.shade700, // Color of the divider
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Color of the text buttons
              ),
            ),
            // Optional: Adjust colors for other elements if needed
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String getNameFromEmail(String email) {
    final parts = email.split('.');
    return parts.isNotEmpty ? parts.first : '';
  }

  void _addExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String title = _titleController.text;
      final String email =
          FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
      final double amount = double.tryParse(_amountController.text) ?? 0.0;
      final String formattedDate =
          _selectedDate.toLocal().toString().split(' ')[0];
      final String name = getNameFromEmail(email);

      if (title.isNotEmpty && amount > 0) {
        final expenseModel = ExpenseModel(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: _selectedDate,
          userEmail: FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
        );

        await _expenseService.addExpense(expenseModel);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully!')),
        );

        _titleController.clear();
        _amountController.clear();
        setState(() {
          _selectedDate = DateTime.now();
          _isLoading = true;
          _loadExpenses();
        });

        var templateParams = {
          'name': name,
          'email': email,
          'title': title,
          'amount': amount.toString(),
          'date': formattedDate,
        };
        //print(templateParams);
        // ignore: use_build_context_synchronously
        sendEmail(context, templateParams);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Header(
                title: 'Financial Overview',
                subtitle: 'Keep Your Finances in Check with Ease'),
            const SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Expense Title',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          borderSide: const BorderSide(
                              color: uddeshhyacolor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16), // Adjust vertical padding
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      minLines: 1, // Minimum number of lines
                      maxLines: 1, // Maximum number of lines
                    ),
                    const SizedBox(height: 12), // Reduced spacing
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          borderSide: const BorderSide(
                              color: uddeshhyacolor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16), // Adjust vertical padding
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },

                      style: const TextStyle(color: Colors.white),
                      minLines: 1, // Minimum number of lines
                      maxLines: 1, // Maximum number of lines
                    ),
                  ],
                )),
            const SizedBox(height: 12), // Reduced spacing
            Container(
              padding: const EdgeInsets.only(left: 8.0), // Adjusted padding
              decoration: BoxDecoration(
                color: Colors.transparent, // Dark background for the container
                borderRadius: BorderRadius.circular(8), // Rounded corners
                border: Border.all(
                    color: Colors.white24, width: 1.5), // Subtle border
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate
                          .toLocal()
                          .toString()
                          .split(' ')[0], // Date display
                      style: const TextStyle(
                        fontSize: 14, // Reduced font size
                        color: Colors.white, // Text color for contrast
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white70, // Icon color
                    ),
                    onPressed: () => _selectDate(context),
                    splashColor: Colors.white30, // Subtle splash effect
                    highlightColor: Colors.white24, // Subtle highlight effect
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 16, right: 16),
              child: ElevatedButton(
                onPressed: _addExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uddeshhyacolor, // Updated background color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _expenses.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[850], // Dark grey background
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2), // Subtle shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              title: Text(
                                expense.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.white70,
                                          size: 13,
                                        ),
                                        Text(
                                          ' ₹${expense.amount}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range_rounded,
                                        color: Colors.white70,
                                        size: 13,
                                      ),
                                      Text(
                                        ' ${expense.date.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.no_accounts_rounded,
                                color: Colors.grey, size: 40),
                            const SizedBox(height: 16),
                            const Text(
                              'No Expense Added',
                              style: TextStyle(
                                  color: textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Text(
                                'It looks like there are no expenses at the moment.',
                                style: TextStyle(
                                    color: Colors.grey.shade300, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
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
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminExpensePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          uddeshhyacolor, // Updated background color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'See All Expenses',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textcolor),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> sendEmail(BuildContext context, dynamic templateParams) async {
    try {
      await emailjs.send(
        'service_b5zy7td',
        'template_mbig9ko',
        templateParams,
        const emailjs.Options(
          publicKey: 'ojbaNzqhe9oOBqSsQ',
          privateKey: 'EIsvo5fAcOV0XrEAI_AQh',
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Email sent successfully!'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
      // print('SUCCESS!');
      return true;
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Failed to send email. Please try again later.'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      //print('Error found: $error');
      return false;
    }
  }
}
