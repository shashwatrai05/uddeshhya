// In syllabus.dart

class Topic {
  final String title;
  final int order;  // Add order field
  bool isCompleted;

  Topic({
    required this.title, 
    required this.order,  // Make order required
    this.isCompleted = false
  });

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      title: map['title'] ?? '',
      order: map['order'] ?? 0,  // Include order in fromMap
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'order': order,  // Include order in toMap
      'isCompleted': isCompleted,
    };
  }
}

class SyllabusModel {
  final String standard;
  final List<Topic> topics;

  SyllabusModel({required this.standard, required this.topics});

  factory SyllabusModel.fromMap(Map<String, dynamic> map) {
    var topicsList = List<Topic>.from((map['topics'] as List<dynamic>)
        .map((item) => Topic.fromMap(item as Map<String, dynamic>)));
    
    // Sort topics by order when creating from map
    topicsList.sort((a, b) => a.order.compareTo(b.order));
    
    return SyllabusModel(
      standard: map['standard'] ?? '',
      topics: topicsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'standard': standard,
      'topics': topics.map((topic) => topic.toMap()).toList(),
    };
  }
}