// services/activity_service.dart

// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/planner.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ActivityModel>> getActivities() async {
    final querySnapshot = await _firestore.collection('activities').get();
    return querySnapshot.docs
        .map((doc) => ActivityModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addActivity(ActivityModel activity) async {
    await _firestore
        .collection('activities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  Future<void> updateActivity(ActivityModel activity) async {
    await _firestore
        .collection('activities')
        .doc(activity.id)
        .update(activity.toMap());
  }

  Future<void> deleteActivity(String activityId) async {
    await _firestore.collection('activities').doc(activityId).delete();
  }
}
