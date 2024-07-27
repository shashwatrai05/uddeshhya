import 'package:flutter/material.dart';
import 'package:uddeshhya/services/expense_service.dart';
import 'package:uddeshhya/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ExpenseService _expenseService = ExpenseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<ExpenseModel> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() async {
    final String email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    final expenses = await _expenseService.getUserExpenses(email);
    setState(() {
      _expenses = expenses;
      _isLoading = false;
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addExpense() async {
    final String title = _titleController.text;
    final double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      final expenseModel = ExpenseModel(
        id: DateTime.now().toString(), // Generate a unique ID for the expense
        title: title,
        amount: amount,
        date: _selectedDate,
        userEmail: FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
      );

      await _expenseService.addExpense(expenseModel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Expense added successfully!')),
      );

      // Clear the fields
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now(); // Reset date to current date
        _isLoading = true; // Reload expenses
        _loadExpenses();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                email.isNotEmpty ? email[0].toUpperCase() : '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              email,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Expense Title'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExpense,
              child: const Text('Add Expense'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return ListTile(
                          title: Text(expense.title),
                          subtitle: Text('Amount: \$${expense.amount}\nDate: ${expense.date.toLocal().toString().split(' ')[0]}'),
                        );
                      },
                    ),
                  ),
                  IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminExpensesPage(),
              ),
            );
          } , icon: const Icon(Icons.abc))
          ],
        ),
      ),
    );
  }
}

class AdminExpensesPage extends StatelessWidget {
  final ExpenseService _expenseService = ExpenseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
      ),
      body: FutureBuilder<List<ExpenseModel>>(
        future: _expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses available.'));
          } else {
            final expenses = snapshot.data!;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text('Amount: \$${expense.amount}\nDate: ${expense.date.toLocal().toString().split(' ')[0]}\nAdded by: ${expense.userEmail}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
