import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:uddeshhya/models/expense.dart';
import '../../../services/expense_service.dart';

class ExpenseController {
  final ExpenseService _expenseService = ExpenseService();
  
  // Get name from email
  String getNameFromEmail(String email) {
    final parts = email.split('.');
    return parts.isNotEmpty ? parts.first : '';
  }

  // Load expenses
  Future<List<ExpenseModel>> loadExpenses() async {
    final String email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    return await _expenseService.getUserExpenses(email);
  }

  // Add expense
  Future<bool> addExpense(ExpenseModel expense) async {
    try {
      await _expenseService.addExpense(expense);
      await _updateGoogleSheets(expense);
      await _sendEmailNotification(expense);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update expense
  Future<bool> updateExpense(ExpenseModel expense) async {
    try {
      await _expenseService.updateExpense(expense);
      await _updateGoogleSheets(expense);
      await _sendEmailNotification(expense);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update Google Sheets
  Future<bool> _updateGoogleSheets(ExpenseModel expense) async {
    final String email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    final String name = getNameFromEmail(email);
    
    var data = {
      'data': [{
        'name': name,
        'email': email,
        'title': expense.title,
        'amount': expense.amount.toString(),
        'date': expense.date.toLocal().toString().split(' ')[0],
      }]
    };

    var response = await http.post(
      Uri.parse('https://sheetdb.io/api/v1/tful8j65g55mc'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return response.statusCode == 201;
  }

  // Send email notification
  Future<bool> _sendEmailNotification(ExpenseModel expense) async {
    try {
      final String email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
      final String name = getNameFromEmail(email);
      
      var templateParams = {
        'name': name,
        'email': email,
        'title': expense.title,
        'amount': expense.amount.toString(),
        'date': expense.date.toLocal().toString().split(' ')[0],
      };

      await emailjs.send(
        'service_b5zy7td',
        'template_mbig9ko',
        templateParams,
        const emailjs.Options(
          publicKey: 'ojbaNzqhe9oOBqSsQ',
          privateKey: 'EIsvo5fAcOV0XrEAI_AQh',
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}