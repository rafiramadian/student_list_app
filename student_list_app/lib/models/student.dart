// To parse this JSON data, do
//
//     final student = studentFromMap(jsonString);

import 'dart:convert';

Student studentFromMap(String str) => Student.fromMap(json.decode(str));

String studentToMap(Student data) => json.encode(data.toMap());

class Student {
  Student({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
  });

  final String id;
  final String name;
  final String lastName;
  final int age;

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"] ?? "",
        lastName: json["lastName"] ?? "",
        age: json["age"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "lastName": lastName,
        "age": age,
      };
}
