import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uddeshhya/services/planner_service.dart';
import 'package:uddeshhya/view/constants/theme.dart';
import 'package:uddeshhya/view/widgets/LiquidProgressIndicator.dart';
import 'package:uddeshhya/view/widgets/header.dart';
import '../../models/planner.dart';
import '../../services/auth_service.dart';

class ActivityPlannerScreen extends StatefulWidget {
  @override
  _ActivityPlannerScreenState createState() => _ActivityPlannerScreenState();
}

class _ActivityPlannerScreenState extends State<ActivityPlannerScreen> {
  final ActivityService _activityService = ActivityService();
  final AuthService _authService = AuthService();
  late Future<List<ActivityModel>> _activitiesFuture;
  late Future<String> _userRole;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = _activityService.getActivities();
    _userRole = _authService.getUserRole(_authService.currentUser!.uid);
  }

  Future<void> _showActivityDialog({ActivityModel? activity}) async {
    final isEditing = activity != null;
    final titleController = TextEditingController(text: activity?.title);
    final remarkController = TextEditingController(text: activity?.remark);
    DateTime selectedDate = activity != null ? activity.date : DateTime.now();
    final dateController =
        TextEditingController(text: DateFormat.yMd().format(selectedDate));

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: Colors.blueAccent, // Color of the selected date
              //accentColor: Colors.teal,  // Color of the date picker header
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary, // Color of the buttons
              ),
              dialogBackgroundColor:
                  Colors.black, // Background color of the date picker
              dividerColor: Colors.teal.shade700, // Color of the divider
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.teal, // Color of the text buttons
                ),
              ),
              // Optional: Adjust colors for other elements if needed
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
          dateController.text = DateFormat.yMd().format(selectedDate);
        });
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.grey[900],
          elevation: 8,
          title: Text(
            isEditing ? 'Edit Activity' : 'Add New Activity',
            style: const TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter activity title',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: 'Select date (MM/DD/YYYY)',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.teal),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.teal, width: 2.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: remarkController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter remark',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.tealAccent,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                isEditing ? 'Update' : 'Add',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final newActivity = ActivityModel(
                  id: isEditing ? activity!.id : DateTime.now().toString(),
                  title: titleController.text,
                  date: selectedDate,
                  remark: remarkController.text,
                );
                if (isEditing) {
                  await _activityService.updateActivity(newActivity);
                } else {
                  await _activityService.addActivity(newActivity);
                }
                setState(() {
                  _activitiesFuture = _activityService.getActivities();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Header(
                title: 'ACTIVITY PLANNER',
                subtitle: 'Plan and manage your activities efficiently.',
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<List<ActivityModel>>(
                  future: _activitiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: LiquidProgressIndicator(
                              value: 50, maxValue: 100));
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: uddeshhyacolor, size: 50),
                            SizedBox(height: 16),
                            Text(
                              'Oops! Something went wrong.',
                              style: TextStyle(
                                  color: textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.no_stroller_rounded,
                                color: Colors.grey, size: 40),
                            const SizedBox(height: 16),
                            const Text(
                              'No Activities Available',
                              style: TextStyle(
                                  color: textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'It looks like there are no activities planned.',
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24)
                          ],
                        ),
                      );
                    }
                    final activities = snapshot.data!;
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded,
                                    color: Colors.white70),
                                const SizedBox(width: 8.0),
                                Text(
                                  '${DateFormat.yMd().format(activity.date)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: 8.0),
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 20.0, top: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 16.0),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '${activity.remark}',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                trailing: FutureBuilder<String>(
                                  future: _userRole,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data == 'admin') {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white),
                                            onPressed: () =>
                                                _showActivityDialog(
                                                    activity: activity),
                                          ),
                                          const SizedBox(width: 8.0),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.white),
                                            onPressed: () async {
                                              await _activityService
                                                  .deleteActivity(activity.id);
                                              setState(() {
                                                _activitiesFuture =
                                                    _activityService
                                                        .getActivities();
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                tileColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<String>(
            future: _userRole,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data != 'admin') {
                return const SizedBox.shrink();
              }
              return FloatingActionButton.extended(
                onPressed: _showActivityDialog,
                label: const Text(
                  'Add Activity',
                  style: TextStyle(color: textcolor),
                ),
                icon: const Icon(
                  Icons.add,
                  color: textcolor,
                ),
                backgroundColor: uddeshhyacolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              );
            },
          ),
        ));
  }
}
