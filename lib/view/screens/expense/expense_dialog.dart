import 'package:flutter/material.dart';

import '../../../models/expense.dart';
import '../../constants/theme.dart';

class ExpenseDialog {
  static Future<ExpenseModel?> showEditDialog(
    BuildContext context,
    ExpenseModel expense,
  ) async {
    final TextEditingController titleController =
        TextEditingController(text: expense.title);
    final TextEditingController amountController =
        TextEditingController(text: expense.amount.toString());
    DateTime selectedDate = expense.date;

    return showDialog<ExpenseModel>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: kUpperContainerColor,
          title: const Text(
            'Edit Expense',
            style: TextStyle(color: textcolor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    selectedDate.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white70),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              primaryColor: Colors.blueAccent,
                              dialogBackgroundColor: Colors.black,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: textcolor)),
            ),
            TextButton(
              onPressed: () {
                final updatedExpense = ExpenseModel(
                  id: expense.id,
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? expense.amount,
                  date: selectedDate,
                  userEmail: expense.userEmail,
                );
                Navigator.pop(context, updatedExpense);
              },
              child: const Text('Update', style: TextStyle(color: uddeshhyacolor)),
            ),
          ],
        ),
      ),
    );
  }
}