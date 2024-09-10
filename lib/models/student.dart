class StudentModel {
  final String id;
  final String name;
  final String standard; // Field for the student's standard
  final Map<String, bool>
      syllabusCompletion; // Track completion status of each topic

  StudentModel({
    required this.id,
    required this.name,
    required this.standard,
    required this.syllabusCompletion,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      standard: map['standard'],
      syllabusCompletion: Map<String, bool>.from(map['syllabusCompletion']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'standard': standard,
      'syllabusCompletion': syllabusCompletion,
    };
  }
}
