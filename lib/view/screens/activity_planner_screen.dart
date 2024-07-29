// screens/activity_planner_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uddeshhya/services/planner_service.dart';
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

  void _showActivityDialog({ActivityModel? activity}) async {
    final isEditing = activity != null;
    final titleController = TextEditingController(text: activity?.title);
    final dateController = TextEditingController(text: activity != null ? DateFormat.yMd().format(activity.date) : '');
    final remarkController = TextEditingController(text: activity?.remark);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Activity' : 'Add New Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(hintText: 'Date (MM/DD/YYYY)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(hintText: 'Remark'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isEditing ? 'Update' : 'Add'),
              onPressed: () async {
                final date = DateFormat.yMd().parse(dateController.text);
                final newActivity = ActivityModel(
                  id: isEditing ? activity!.id : DateTime.now().toString(),
                  title: titleController.text,
                  date: date,
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
      appBar: AppBar(
        title: const Text('Activity Planner'),
        actions: <Widget>[
          FutureBuilder<String>(
            future: _userRole,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData && snapshot.data == 'admin') {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showActivityDialog(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ActivityModel>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities available.'));
          }
          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                title: Text(activity.title),
                subtitle: Text('${DateFormat.yMd().format(activity.date)} - ${activity.remark}'),
                trailing: FutureBuilder<String>(
                  future: _userRole,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.hasData && snapshot.data == 'admin') {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showActivityDialog(activity: activity),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _activityService.deleteActivity(activity.id);
                              setState(() {
                                _activitiesFuture = _activityService.getActivities();
                              });
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
