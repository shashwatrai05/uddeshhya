import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uddeshhya/models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addExpense(ExpenseModel expense) async {
    final email = expense.userEmail;
    final expenseRef = _db.collection('expenses').doc(email).collection('user_expenses').doc(expense.id);

    await expenseRef.set({
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date,
      'userEmail': expense.userEmail,
    });
  }

  Future<List<ExpenseModel>> getUserExpenses(String email) async {
    final expenseCollection = _db.collection('expenses').doc(email).collection('user_expenses');
    final querySnapshot = await expenseCollection.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ExpenseModel(
        id: doc.id,
        title: data['title'] ?? '',
        amount: (data['amount'] ?? 0.0).toDouble(),
        date: (data['date'] as Timestamp).toDate(),
        userEmail: data['userEmail'] ?? '',
      );
    }).toList();
  }

  Future<void> deleteExpense(String email, String expenseId) async {
    final expenseRef = _db.collection('expenses').doc(email).collection('user_expenses').doc(expenseId);

    await expenseRef.delete();
  }

 Future<List<String>> getUserEmails() async {
  try {
    // Get the list of documents from the 'expenses' collection
    final snapshot = await _db.collection('expenses').get();
    
    // Check if any documents are returned
    if (snapshot.docs.isEmpty) {
      //print('No documents found in the expenses collection.');
      return []; // Return an empty list if no documents are found
    } else {
      // Map document IDs to a list of strings (assuming document IDs are emails)
      final emailList = snapshot.docs.map((doc) => doc.id).toList();
      //print('Fetched emails are: $emailList');
      return emailList; // Return the list of email IDs
    }
  } catch (e) {
    //print('Print Statement:: Error fetching user emails: $e');
    rethrow; // Re-throw the exception to signal an error
  }
}

  Future<List<ExpenseModel>> getExpenses(String userEmail) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .doc(userEmail)
        .collection('user_expenses')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ExpenseModel(
        id: doc.id,
        title: data['title'] ?? '',
        amount: data['amount'] ?? 0.0,
        date: (data['date'] as Timestamp).toDate(),
        userEmail: data['userEmail'] ?? '',
      );
    }).toList();
  } catch (e) {
    //print('Print Statement:: Error fetching expenses in services: $e');
    rethrow;
  }
}


}
