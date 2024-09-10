import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendExpenseToGoogleSheets(
    String date, double amount, String description) async {
  final url = Uri.parse('https://sheetdb.io/api/v1/zwujse6bu70sr');

  // Data to send
  final Map<String, dynamic> expenseData = {
    'Date': date,
    'Amount': amount.toString(),
    'Description': description,
  };

  // Sending POST request
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'data': [expenseData]
      }),
    );

    if (response.statusCode == 201) {
      print('Expense added successfully');
    } else {
      print('Failed to add expense: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
