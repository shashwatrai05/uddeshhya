class Topic {
  final String title;
  bool isCompleted;

  Topic({required this.title, this.isCompleted = false});

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class SyllabusModel {
  final String standard;
  final List<Topic> topics;

  SyllabusModel({required this.standard, required this.topics});

  factory SyllabusModel.fromMap(Map<String, dynamic> map) {
    return SyllabusModel(
      standard: map['standard'] ?? '',
      topics: List<Topic>.from((map['topics'] as List<dynamic>)
          .map((item) => Topic.fromMap(item as Map<String, dynamic>))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'standard': standard,
      'topics': topics.map((topic) => topic.toMap()).toList(),
    };
  }
}
