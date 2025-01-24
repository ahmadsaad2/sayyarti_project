class WorkAssignment {
  int id;
  String day;
  String task;
  bool worked;

  WorkAssignment({
    required this.id,
    required this.day,
    required this.task,
    required this.worked,
  });

  factory WorkAssignment.fromJson(Map<String, dynamic> json) {
    return WorkAssignment(
      id: json['id'] ?? 0,
      day: json['day'] ?? '',
      task: json['task'] ?? '',
      worked: json['worked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'task': task,
      'worked': worked,
    };
  }
}
