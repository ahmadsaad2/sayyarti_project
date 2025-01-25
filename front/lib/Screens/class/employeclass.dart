// // import 'work_assignment.dart';

// // class Employee {
// //   int id;
// //   int userId;

// //   String name;
// //   String email;
// //    String contact;
// //   String role;

// //   final List<WorkAssignment> workAssignments;

// //   Employee({
// //     required this.id,
// //     required this.name,
// //     required this.role,
// //     required this.userId,
// //     required this.workAssignments,
// //     this.email = '',
// //     this.contact = '',
// //   });

// //   factory Employee.fromJson(Map<String, dynamic> json) {
// //     return Employee(
// //       id: json['id'] ?? 0, // Default to 0 if 'id' is missing
// //       userId: json['user_id'] ?? 0,
// //       email: json['email'],
// //       // Default to 0 if 'user_id' is missing
// //       name: json['name']?.toString().trim().isEmpty ?? true
// //           ? 'Unknown' // Default to 'Unknown' if 'name' is empty or null
// //           : json['name'], // Use the provided name
// //       role: json['role'] ??
// //           'Unknown', // Default to 'Unknown' if 'role' is missing
// //       workAssignments: (json['tasks'] as List<dynamic>?)
// //               ?.map((assignment) => WorkAssignment.fromJson(assignment))
// //               .toList() ??
// //           [], // Default to an empty list if 'tasks' is missing
// //     );
// //   }

// //   // Serialize to JSON
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'name': name,
// //       'email': email,
// //       'position': role,
// //       'contact': contact,
// //       'workAssignments':
// //           workAssignments.map((assignment) => assignment.toJson()).toList(),
// //     };
// //   }
// // }
// import 'work_assignment.dart';

// class Employee {
//   int id;
//   int userId;
//   String name;
//   String? email; // Declare as nullable
//   String? contact; // Declare as nullable
//   String role;
//   final List<WorkAssignment> workAssignments;

//   Employee({
//     required this.id,
//     required this.name,
//     required this.role,
//     required this.userId,
//     required this.workAssignments,
//     this.email, // No default value needed for nullable fields
//     this.contact, // No default value needed for nullable fields
//   });

//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       id: json['id'] ?? 0, // Default to 0 if 'id' is missing
//       userId: json['user_id'] ?? 0, // Default to 0 if 'user_id' is missing
//       name: json['name']?.toString().trim().isEmpty ?? true
//           ? 'Unknown' // Default to 'Unknown' if 'name' is empty or null
//           : json['name'], // Use the provided name
//       role: json['role'] ??
//           'Unknown', // Default to 'Unknown' if 'role' is missing
//       email: json['email'], // Can be null
//       contact: json['contact'], // Can be null
//       workAssignments: (json['tasks'] as List<dynamic>?)
//               ?.map((assignment) => WorkAssignment.fromJson(assignment))
//               .toList() ??
//           [], // Default to an empty list if 'tasks' is missing
//     );
//   }

//   // Serialize to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'position': role,
//       'contact': contact,
//       'workAssignments':
//           workAssignments.map((assignment) => assignment.toJson()).toList(),
//     };
//   }
// }
// lib/class/employeclass.dart
import 'work_assignment.dart';
import 'task.dart';

class Employee {
  int id;
  int userId;
  String name;
  String? email; // Nullable
  String? contact; // Nullable
  String role;
  final List<WorkAssignment> workAssignments;
  final List<Task> tasks; // Assuming you have a Task class

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.userId,
    required this.workAssignments,
    required this.tasks,
    this.email,
    this.contact,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name']?.toString().trim().isEmpty ?? true
          ? 'Unknown'
          : json['name'],
      role: json['role'] ?? 'Unknown',
      email: json['email'],
      contact: json['contact'],
      workAssignments: (json['workAssignments'] as List<dynamic>?)
              ?.map((assignment) => WorkAssignment.fromJson(assignment))
              .toList() ??
          [],
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => Task.fromJson(task))
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
      'position': role,
      'contact': contact,
      'workAssignments':
          workAssignments.map((assignment) => assignment.toJson()).toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}
