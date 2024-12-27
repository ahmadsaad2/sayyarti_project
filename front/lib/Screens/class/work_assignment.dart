class WorkAssignment {
  String day;
  String task;
  String status; // Status: "waiting", "In Progress", "Complete"
  bool worked;
  String details; // Add this line

  WorkAssignment({
    required this.day,
    required this.task,
    this.status = "waiting", // Default status
    this.worked = false,
    this.details = "",
  });
}
