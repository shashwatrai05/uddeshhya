import 'package:flutter/material.dart';
import 'package:uddeshhya/services/expense_service.dart';
import 'package:uddeshhya/models/expense.dart';
import 'package:uddeshhya/view/constants/theme.dart';

class AdminExpensePage extends StatefulWidget {
  const AdminExpensePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminExpensePageState createState() => _AdminExpensePageState();
}

class _AdminExpensePageState extends State<AdminExpensePage> {
  final ExpenseService _expenseService = ExpenseService();
  List<String> _userEmails = [];
  Map<String, List<ExpenseModel>> _userExpenses = {};
  Map<String, double> _userTotalExpenses = {};
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user emails: $e')),
      );
    }
  }

  void _loadExpensesForAllUsers() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, List<ExpenseModel>> tempExpenses = {};
    final Map<String, double> tempTotalExpenses = {};

    for (String email in _userEmails) {
      try {
        final expenses = await _expenseService.getExpenses(email);
        tempExpenses[email] = expenses;
        double totalExpenses = expenses.fold(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
        tempTotalExpenses[email] = totalExpenses;
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading expenses for user $email: $e')),
        );
      }
    }

    setState(() {
      _userExpenses = tempExpenses;
      _userTotalExpenses = tempTotalExpenses;
      _isLoading = false;
    });
  }

  void _deleteExpense(String email, String expenseId) async {
    try {
      await _expenseService.deleteExpense(email, expenseId);
      _loadExpensesForAllUsers();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete expense')),
      );
    }
  }

  void _deleteAllExpenses(String email) async {
    try {
      final expenses = await _expenseService.getExpenses(email);
      for (var expense in expenses) {
        await _expenseService.deleteExpense(email, expense.id);
      }
      _loadExpensesForAllUsers();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete all expenses')),
      );
    }
  }

  Future<void> _showConfirmDialog(
      String email, String title, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: const Text('Are you sure you want to continue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text(
          'All Expenses',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userExpenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.no_accounts_rounded,
                          color: Colors.grey, size: 50),
                      const SizedBox(height: 20),
                      const Text(
                        'No Expenses Available',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'It looks like there are no expenses available at the moment.',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: _userExpenses.entries.map((entry) {
                    final email = entry.key;
                    final expenses = entry.value;
                    final totalExpense = _userTotalExpenses[email] ?? 0.0;
                    return ExpansionTile(
                      title: Text(
                        '$email \n Total: ₹${totalExpense.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showConfirmDialog(email, 'Delete All Expenses',
                              () => _deleteAllExpenses(email));
                        },
                      ),
                      children: expenses.map((expense) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              expense.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        '₹${expense.amount}',
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range_rounded,
                                        color: Colors.white70, size: 16),
                                    Text(
                                      ' ${expense.date.toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showConfirmDialog(email, 'Delete Expense',
                                    () => _deleteExpense(email, expense.id));
                              },
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
