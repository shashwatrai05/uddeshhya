import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uddeshhya/view/screens/expense/expense_controller.dart';
import '../../../models/expense.dart';
import '../../../services/auth_service.dart';
import '../../constants/theme.dart';
import '../../widgets/header.dart';
import '../admin_expense_page.dart';
import 'expense_dialog.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ExpenseController _controller = ExpenseController();
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  DateTime _selectedDate = DateTime.now();
  List<ExpenseModel> _expenses = [];
  bool _isLoading = true;
  late Future<String> _userRole;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _userRole = _authService.getUserRole(FirebaseAuth.instance.currentUser!.uid);
  }

  void _loadExpenses() async {
    try {
      final expenses = await _controller.loadExpenses();
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load expenses')),
        );
      }
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
            primaryColor: Colors.blueAccent,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            dialogBackgroundColor: Colors.black,
            dividerColor: Colors.teal.shade700,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
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

  void _addExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      final expense = ExpenseModel(
        id: DateTime.now().toString(),
        title: _titleController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        date: _selectedDate,
        userEmail: FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
      );

      final success = await _controller.addExpense(expense);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully!')),
          );
          _titleController.clear();
          _amountController.clear();
          setState(() {
            _selectedDate = DateTime.now();
            _loadExpenses();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add expense')),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showEditExpenseDialog(ExpenseModel expense) async {
    final updatedExpense = await ExpenseDialog.showEditDialog(context, expense);
    if (updatedExpense != null) {
      setState(() => _isLoading = true);
      final success = await _controller.updateExpense(updatedExpense);
      
      if (mounted) {
        if (success) {
          _loadExpenses();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update expense')),
          );
          setState(() => _isLoading = false);
        }
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
              subtitle: 'Keep Your Finances in Check with Ease'
            ),
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
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: uddeshhyacolor,
                          width: 1.5
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    minLines: 1,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: uddeshhyacolor,
                          width: 1.5
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate.toLocal().toString().split(' ')[0],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white70),
                    onPressed: () => _selectDate(context),
                    splashColor: Colors.white30,
                    highlightColor: Colors.white24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: uddeshhyacolor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
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
            _buildExpensesList(),
            _buildAdminButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_accounts_rounded, color: Colors.grey, size: 40),
            const SizedBox(height: 16),
            const Text(
              'No Expense Added',
              style: TextStyle(
                color: textcolor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'It looks like there are no expenses at the moment.',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  child: Text(
                    '₹${expense.amount}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
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
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _showEditExpenseDialog(expense),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FutureBuilder<String>(
        future: _userRole,
        builder: (context, snapshot) {
          if (!snapshot.hasData || 
              (snapshot.data != 'finance_team' && snapshot.data != 'super_admin')) {
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
              backgroundColor: uddeshhyacolor,
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
                color: textcolor
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}