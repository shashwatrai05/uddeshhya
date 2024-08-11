import 'package:flutter/material.dart';
import 'package:uddeshhya/services/expense_service.dart';
import 'package:uddeshhya/models/expense.dart';

class AdminExpensePage extends StatefulWidget {
  @override
  _AdminExpensePageState createState() => _AdminExpensePageState();
}

class _AdminExpensePageState extends State<AdminExpensePage> {
  final ExpenseService _expenseService = ExpenseService();
  List<String> _userEmails = [];
  Map<String, List<ExpenseModel>> _userExpenses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmails();
  }

  void _loadUserEmails() async {
    try {
      final emails = await _expenseService.getUserEmails();
      setState(() {
        _userEmails = emails;
        _isLoading = false;
      });
      _loadExpensesForAllUsers();
    } catch (e) {
      print('Print Statement:: Error loading user emails: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print Statement:: Failed to load user emails: $e')),
      );
    }
  }

  void _loadExpensesForAllUsers() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, List<ExpenseModel>> tempExpenses = {};
    
    for (String email in _userEmails) {
      try {
        final expenses = await _expenseService.getExpenses(email);
        tempExpenses[email] = expenses;
        print('Print Statement:: Expenses for $email: $expenses');  // Debugging line
      } catch (e) {
        print('Print Statement:: Error loading expenses for user $email: $e');
      }
    }

    setState(() {
      _userExpenses = tempExpenses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('All Expenses'),
        backgroundColor: Colors.grey[900],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userExpenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.no_accounts_rounded, color: Colors.grey, size: 40),
                      const SizedBox(height: 16),
                      const Text(
                        'No Expenses Available',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'It looks like there are no expenses available at the moment.',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: _userExpenses.entries.map((entry) {
                    final email = entry.key;
                    final expenses = entry.value;
                    return ExpansionTile(
                      title: Text(
                        email,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      children: expenses.map((expense) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              expense.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.monetization_on, color: Colors.white70, size: 13),
                                      Text(
                                        ' \₹${expense.amount}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range_rounded, color: Colors.white70, size: 13),
                                    Text(
                                      ' ${expense.date.toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
    );
  }
}
