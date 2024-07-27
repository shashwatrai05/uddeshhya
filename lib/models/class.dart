// class_model.dart

class ClassModel {
  final String id;
  final String name;

  ClassModel({
    required this.id,
    required this.name,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
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
