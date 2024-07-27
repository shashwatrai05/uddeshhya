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
    required this.date,
    required this.amount,
    required this.userEmail,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: (map['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      userEmail: map['userEmail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date, // Save DateTime
      'userEmail': userEmail,
    };
  }
}
