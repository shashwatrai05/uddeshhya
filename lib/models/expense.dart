import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String userEmail;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.userEmail,
  });

  // Convert a Firestore document into an ExpenseModel instance
  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
      userEmail: data['userEmail']??'',
    );
  }

  // Convert an ExpenseModel instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'userEmail': userEmail,
    };
  }
}
