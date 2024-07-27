// student_model.dart

class StudentModel {
  final String id;
  final String name;

  StudentModel({
    required this.id,
    required this.name,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
