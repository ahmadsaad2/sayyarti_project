// lib/class/task.dart
class Task {
  int id;
  int employeeId;
  String task;
  String day;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.employeeId,
    required this.task,
    required this.day,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      task: json['task'] ?? '',
      day: json['day'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'task': task,
        'day': day,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
