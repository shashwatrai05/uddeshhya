import 'package:flutter/material.dart';
import 'package:uddeshhya/services/expense_service.dart';
import 'package:uddeshhya/models/expense.dart';

import '../constants/theme.dart';

class AdminExpensesPage extends StatefulWidget {
  @override
  _AdminExpensesPageState createState() => _AdminExpensesPageState();
}

class _AdminExpensesPageState extends State<AdminExpensesPage> {
  final ExpenseService _expenseService = ExpenseService();
  late Future<List<ExpenseModel>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _expenseService.getExpenses();
  }

  Future<void> _refreshExpenses() async {
    setState(() {
      _expensesFuture = _expenseService.getExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.black.withOpacity(0.6), // Semi-transparent background
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: RefreshIndicator(
        onRefresh: _refreshExpenses,
        child: FutureBuilder<List<ExpenseModel>>(
          future: _expensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No expenses available.', style: TextStyle(color: Colors.white)));
            } else {
              final expenses = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16), // Padding around the list
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16), // Margin between items
                    decoration: BoxDecoration(
                      color: Colors.grey[850], // Darker grey for a more consistent theme
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Darker shadow for more depth
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4), // More pronounced shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      dense: true, // Reduced padding for a compact look
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        expense.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Align text to start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee_rounded,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  Text(
                                    '${expense.amount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16), // Space between elements
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  Text(
                                    '  ${expense.date.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // Space before "Added by"
                          Text(
                            'Added by: ${expense.userEmail}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final bool confirm = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this expense?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          ) ?? false;

                          if (confirm) {
                            await _expenseService.deleteExpense(expense.id);
                            _refreshExpenses(); // Refresh the list after deletion
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
