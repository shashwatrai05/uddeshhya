import 'package:flutter/material.dart';

class ClassSelector extends StatelessWidget {
  final List<String> classes;
  final void Function(String?)? onClassSelected; // Updated to handle nullable String

  ClassSelector({required this.classes, this.onClassSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: const Text('Select Class'),
      onChanged: onClassSelected, // Pass the updated callback function
      items: classes.map((className) {
        return DropdownMenuItem(
          value: className,
          child: Text(className),
        );
      }).toList(),
    );
  }
}
