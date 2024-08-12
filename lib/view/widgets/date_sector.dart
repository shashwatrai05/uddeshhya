import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const DateSelector({super.key, 
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: date == selectedDate ? Colors.blue : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    color: date == selectedDate ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
