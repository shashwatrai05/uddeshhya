import 'package:flutter/material.dart';
import 'attendance_percentage.dart'; // Import the Attendance Percentages Screen
import '../../../models/attendance.dart';
import '../../../services/attendance_service.dart';
import '../../constants/theme.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final String className;

  const AttendanceHistoryScreen({required this.className, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceHistoryScreenState createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceModel>? _attendanceRecords;
  Map<String, double>? _attendancePercentages;
  AttendanceModel? _selectedRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory(widget.className);
  }

  Future<void> _loadAttendanceHistory(String className) async {
    try {
      final records = await _attendanceService.getAttendanceHistory(className);
      setState(() {
        _attendanceRecords = records.isEmpty ? [] : records;
        _attendancePercentages = AttendanceModel.calculateAttendancePercentages(records);
        if (_attendanceRecords!.isNotEmpty) {
          _selectedRecord = _attendanceRecords![0]; // Default to the first record
        }
        _isLoading = false;
      });
    } catch (e) {
      // Handle error (e.g., show a Snackbar or an error message)
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onDateSelected(AttendanceModel record) {
    setState(() {
      _selectedRecord = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance History for ${widget.className}',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: uddeshhyacolor))
          : _attendanceRecords == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: uddeshhyacolor, size: 50),
                      const SizedBox(height: 16),
                      const Text(
                        'Oops! Something went wrong.',
                        style: TextStyle(
                            color: textcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: textcolor, 
                          backgroundColor: uddeshhyacolor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : _attendanceRecords!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.no_accounts_rounded, color: Colors.grey, size: 40),
                          const SizedBox(height: 16),
                          const Text(
                            'No Attendance Record Found',
                            style: TextStyle(
                                color: textcolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'There is no attendance record for this class at this moment.',
                              style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: textcolor, 
                              backgroundColor: uddeshhyacolor,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Go Back'),
                          ),
                        ],
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.069,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _attendanceRecords!.map((record) {
                                return GestureDetector(
                                  onTap: () => _onDateSelected(record),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: _selectedRecord == record ? Colors.blue : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 8.0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${record.date.toLocal()}'.split(' ')[0],
                                        style: TextStyle(
                                          color: _selectedRecord == record ? Colors.white : Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        _selectedRecord == null
                            ? SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'No Record Selected',
                                    style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final entry = _selectedRecord!.studentAttendance.entries.toList()[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        title: Text(
                                          entry.key,
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                        trailing: Text(
                                          entry.value ? 'Present' : 'Absent',
                                          style: TextStyle(
                                            color: entry.value ? Colors.green : Colors.red,
                                          ),
                                        ),
                                        tileColor: Colors.grey[850],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: _selectedRecord!.studentAttendance.length,
                                ),
                              ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_attendancePercentages != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AttendancePercentagesScreen(attendancePercentages: _attendancePercentages!),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Attendance percentages are not available.'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: textcolor,
                                backgroundColor: uddeshhyacolor,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('View Attendance Percentages'),
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
