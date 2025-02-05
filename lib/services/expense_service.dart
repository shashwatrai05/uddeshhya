import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uddeshhya/models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<void> addExpense(ExpenseModel expense) async {
  //   final email = expense.userEmail;
  //   final expenseRef = _db
  //       .collection('expenses')
  //       .doc(email)
  //       .collection('user_expenses')
  //       .doc(expense.id);

  //   await expenseRef.set({
  //     'title': expense.title,
  //     'amount': expense.amount,
  //     'date': expense.date,
  //     'userEmail': expense.userEmail,
  //   });
  // }

  Future<void> addExpense(ExpenseModel expense) async {
  try {
    // First, ensure the user document exists
    final userDocRef = _db.collection('expenses').doc(expense.userEmail);
    await userDocRef.set({
      'email': expense.userEmail,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Then add the expense
    final expenseRef = userDocRef
        .collection('user_expenses')
        .doc(expense.id);

    await expenseRef.set(expense.toMap());
  } catch (e) {
    throw 'Failed to add expense: $e';
  }
}

  Future<List<ExpenseModel>> getUserExpenses(String email) async {
    final expenseCollection =
        _db.collection('expenses').doc(email).collection('user_expenses');
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



  // Delete a single expense
  Future<void> deleteExpense(String email, String expenseId) async {
    try {
      await _db
          .collection('expenses')
          .doc(email)
          .collection('user_expenses')
          .doc(expenseId)
          .delete();

      // Check if this was the last expense
      final remaining = await _db
          .collection('expenses')
          .doc(email)
          .collection('user_expenses')
          .limit(1)
          .get();

      // If no expenses left, delete the parent document
      if (remaining.docs.isEmpty) {
        await _db.collection('expenses').doc(email).delete();
      }
    } catch (e) {
      throw 'Failed to delete expense: $e';
    }
  }

 Future<void> deleteAllUserExpenses(String email) async {
    try {
      // Get all expenses first
      final QuerySnapshot expensesSnapshot = await _db
          .collection('expenses')
          .doc(email)
          .collection('user_expenses')
          .get();

      // Delete all expense documents in a batch
      final WriteBatch batch = _db.batch();
      for (var doc in expensesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Finally delete the main user document
      await _db.collection('expenses').doc(email).delete();
    } catch (e) {
      throw 'Failed to delete all expenses: $e';
    }
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

  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      final expenseRef = _db
          .collection('expenses')
          .doc(expense.userEmail)
          .collection('user_expenses')
          .doc(expense.id);

      await expenseRef.update(expense.toMap());
    } catch (e) {
      throw 'Failed to update expense: $e';
    }
  }
}
