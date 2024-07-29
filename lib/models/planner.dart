// models/activity.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String title;
  final DateTime date;
  final String remark;

  ActivityModel({
    required this.id,
    required this.title,
    required this.date,
    required this.remark,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> data) {
    return ActivityModel(
      id: data['id'] as String,
      title: data['title'] as String,
      date: (data['date'] as Timestamp).toDate(),
      remark: data['remark'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': Timestamp.fromDate(date),
      'remark': remark,
    };
  }
}
