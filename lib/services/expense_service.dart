import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense.dart'; // Import FirebaseAuth

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ExpenseModel>> getUserExpenses(String userEmail) async {
    final querySnapshot = await _firestore
        .collection('expenses')
        .where('userEmail', isEqualTo: userEmail)
        .get();
    return querySnapshot.docs.map((doc) => ExpenseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final querySnapshot = await _firestore.collection('expenses').get();
    return querySnapshot.docs.map((doc) => ExpenseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addExpense(ExpenseModel expenseModel) async {
    final user = _auth.currentUser;
    final userEmail = user?.email ?? 'Unknown';

    final updatedExpenseModel = ExpenseModel(
      id: expenseModel.id,
      title: expenseModel.title,
      amount: expenseModel.amount,
      date: expenseModel.date,
      userEmail: userEmail,
    );

    await _firestore.collection('expenses').doc(expenseModel.id).set(updatedExpenseModel.toMap());
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
  }
}
