// import 'package:flutter/material.dart';
// import 'package:uddeshhya/services/expense_service.dart';
// import 'package:uddeshhya/models/expense.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../constants/theme.dart';

// class TotalExpensePage extends StatefulWidget {
//   @override
//   _TotalExpensePageState createState() => _TotalExpensePageState();
// }

// class _TotalExpensePageState extends State<TotalExpensePage> {
//   final ExpenseService _expenseService = ExpenseService();
//   late Future<double> _totalExpenseFuture;

//   @override
//   void initState() {
//     super.initState();
//     _totalExpenseFuture = _calculateTotalExpense();
//   }

//   Future<double> _calculateTotalExpense() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return 0.0; // No user logged in
//     }
//     final expenses = await _expenseService.getUserExpenses(user.email!);

//     // Sum up the expenses
//     double totalExpense = 0.0;
//     for (var expense in expenses) {
//       totalExpense += expense.amount;
//     }

//     return totalExpense;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Total Expense',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: textcolor,
//           ),
//         ),
//         elevation: 5,
//         backgroundColor: Colors.black.withOpacity(0.6), // Semi-transparent background
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       backgroundColor: bgcolor,
//       body: Center(
//         child: FutureBuilder<double>(
//           future: _totalExpenseFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white));
//             } else {
//               final totalExpense = snapshot.data ?? 0.0;
//               return Text(
//                 'Total Expense: ₹${totalExpense.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
