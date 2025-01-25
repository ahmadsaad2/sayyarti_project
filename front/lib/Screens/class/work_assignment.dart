// class WorkAssignment {
//   final int id;
//   final int employeeId;
//   final String day;
//   late String work;
//   bool worked;

//   WorkAssignment({
//     required this.id,
//     this.employeeId = 0,
//     this.day = 'Unknown',
//     this.work = '',
//     this.worked = false,
//   });

//   factory WorkAssignment.fromJson(Map<String, dynamic> json) {
//     return WorkAssignment(
//       id: json['id'] ?? 0,
//       employeeId: json['employee_id'] ?? 0,
//       day: json['day'] ?? 'Unknown',
//       work: json['work'] ?? '',
//       worked: json['worked'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'employee_id': employeeId,
//         'day': day,
//         'work': work,
//         'worked': worked,
//       };
// }

class WorkAssignment {
  final int id;
  final int employeeId;
  final String day;
  String task; // Update from 'work' to 'task'
  bool worked;

  WorkAssignment({
    required this.id,
    this.employeeId = 0,
    this.day = 'Unknown',
    this.task = '', // Update from 'work' to 'task'
    this.worked = false,
  });

  factory WorkAssignment.fromJson(Map<String, dynamic> json) {
    return WorkAssignment(
      id: json['id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      day: json['day'] ?? 'Unknown',
      task: json['task'] ?? '', // Map the correct backend field
      worked: json['worked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'day': day,
        'task': task, // Update from 'work' to 'task'
        'worked': worked,
      };
}
