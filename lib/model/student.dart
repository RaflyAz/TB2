final String studentTable = 'student';

class StudentFields {

  static final List<String> values = [
    id, name, nim, phone, email
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String nim = 'nim';
  static final String phone = 'phone';
  static final String email = 'email';

}

class Student {
  final int? id;
  final String name;
  final String nim;
  final String phone;
  final String email;

  const Student({
    this.id,
    required this.name,
    required this.nim,
    required this.phone,
    required this.email,

  });

  Map <String, Object?> toJson() => {
    StudentFields.id: id,
    StudentFields.name: name,
    StudentFields.nim: nim,
    StudentFields.phone: phone,
    StudentFields.email: email,
  };

  Student copy ({
    int? id,
    String? name,
    String? nim,
    String? phone,
    String? email,

  }) => Student(
    id: id?? this.id,
    name: name?? this.name,
    nim: nim?? this.nim,
    phone: phone?? this.phone,
    email: email?? this.email,
  );

  static Student fromJson(Map <String, Object?> json) => Student(
    id: json[StudentFields.id] as int?,
    name: json[StudentFields.name] as String,
    nim: json[StudentFields.nim] as String,
    phone: json[StudentFields.phone] as String,
    email: json[StudentFields.email] as String,
  );

}