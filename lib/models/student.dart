class StudentModel {
  final String id;
  final String name;
  final String standard; // New field
  final Map<String, bool> syllabusCompletion; // New field

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
