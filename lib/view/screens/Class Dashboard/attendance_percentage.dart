import 'package:flutter/material.dart';
import '../../constants/theme.dart';

class AttendancePercentagesScreen extends StatefulWidget {
  final Map<String, double> attendancePercentages;

  const AttendancePercentagesScreen(
      {required this.attendancePercentages, Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AttendancePercentagesScreenState createState() =>
      _AttendancePercentagesScreenState();
}

class _AttendancePercentagesScreenState
    extends State<AttendancePercentagesScreen> {
  String _searchQuery = ''; // State variable for search query

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, double>> filteredEntries =
        widget.attendancePercentages.entries.where((entry) {
      return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Percentages',
          style: TextStyle(
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
            // Slimmer search bar
            SizedBox(
              height: 48, // Reduced height
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                style: const TextStyle(color: textcolor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: uddeshhyacolor),
                  hintText: 'Search by student name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: uddeshhyacolor, width: 1.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: uddeshhyacolor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Adjust vertical padding
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Constrained ListView with Flexible
            Expanded(
              child: ListView(
                //padding: const EdgeInsets.all(8.0),
                children: filteredEntries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${entry.value.toStringAsFixed(2)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      tileColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
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
