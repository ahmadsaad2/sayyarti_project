import 'work_assignment.dart';

class Employee {
  final int id;
  final String name;
  final String email;
  final String position;
  final String contact;
  final List<WorkAssignment> workAssignments;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.contact,
    required this.workAssignments,
  });

  // Deserialize from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['user']['name'] ?? '', // User's name from nested JSON
      email: json['user']['email'] ?? '', // User's email from nested JSON
      position: json['role'] ?? '', // Role is part of the employee
      contact:
          json['user']['contact'] ?? 'No Contact', // Assuming `contact` exists
      workAssignments: (json['workAssignments'] as List<dynamic>?)
              ?.map((item) => WorkAssignment.fromJson(item))
              .toList() ??
          [],
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'contact': contact,
      'workAssignments':
          workAssignments.map((assignment) => assignment.toJson()).toList(),
    };
  }
}
