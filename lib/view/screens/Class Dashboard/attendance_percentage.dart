import 'package:flutter/material.dart';
import '../../constants/theme.dart';

class AttendancePercentagesScreen extends StatefulWidget {
  final Map<String, double> attendancePercentages;

  const AttendancePercentagesScreen({required this.attendancePercentages, Key? key}) : super(key: key);

  @override
  _AttendancePercentagesScreenState createState() => _AttendancePercentagesScreenState();
}

class _AttendancePercentagesScreenState extends State<AttendancePercentagesScreen> {
  String _searchQuery = ''; // State variable for search query

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, double>> _filteredEntries = widget.attendancePercentages.entries.where((entry) {
      return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Percentages',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textcolor,
          ),
        ),
        elevation: 15,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.tealAccent),
                hintText: 'Search by student name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.tealAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.tealAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _filteredEntries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black54,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        '${entry.value.toStringAsFixed(2)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      tileColor: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
