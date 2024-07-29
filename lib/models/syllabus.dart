class SyllabusModel {
  final String standard;
  final List<String> topics;

  SyllabusModel({required this.standard, required this.topics});

  factory SyllabusModel.fromMap(Map<String, dynamic> map) {
    return SyllabusModel(
      standard: map['standard'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'standard': standard,
      'topics': topics,
    };
  }
}
