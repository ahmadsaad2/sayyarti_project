import 'work_assignment.dart';

class Employee {
  late String name;
  late String email; // Add the email field
  late String position;
  late String contact;
  late final List<WorkAssignment> workAssignments;

  Employee({
    required this.name,
    required this.email, // Initialize email
    required this.position,
    required this.contact,
    required this.workAssignments,
  });
}

// Mock employee data
final List<Employee> employees = [
  Employee(
    name: "John Doe",
    email: "john.doe@example.com",
    position: "Mechanic",
    contact: "123-456-7890",
    workAssignments: [
      WorkAssignment(
        day: "Monday",
        task: "Oil Change",
        status: "In Progress",
      ),
      WorkAssignment(
        day: "Tuesday",
        task: "Tire Replacement",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Tuesday",
        task: "Brake Inspection",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Wednesday",
        task: "Battery Replacement",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Wednesday",
        task: "Headlight Adjustment",
        status: "Complete",
      ),
      WorkAssignment(
        day: "Thursday",
        task: "Air Filter Replacement",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Friday",
        task: "Engine Diagnostics",
        status: "In Progress",
      ),
      WorkAssignment(
        day: "Friday",
        task: "Paint Touch-Up",
        status: "Complete",
      ),
      WorkAssignment(
        day: "Saturday",
        task: "Wheel Alignment",
        status: "waiting",
      ),
    ],
  ),
  Employee(
    name: "Jane Smith",
    email: "jane.smith@example.com",
    position: "Electrician",
    contact: "987-654-3210",
    workAssignments: [
      WorkAssignment(
        day: "Monday",
        task: "Oil Change",
        status: "In Progress",
      ),
      WorkAssignment(
        day: "Tuesday",
        task: "Tire Replacement",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Tuesday",
        task: "Brake Inspection",
        status: "Complete",
      ),
      WorkAssignment(
        day: "Wednesday",
        task: "Battery Replacement",
        status: "In Progress",
      ),
      WorkAssignment(
        day: "Wednesday",
        task: "Headlight Adjustment",
        status: "Complete",
      ),
      WorkAssignment(
        day: "Thursday",
        task: "Air Filter Replacement",
        status: "waiting",
      ),
      WorkAssignment(
        day: "Friday",
        task: "Engine Diagnostics",
        status: "In Progress",
      ),
      WorkAssignment(
        day: "Friday",
        task: "Paint Touch-Up",
        status: "Complete",
      ),
      WorkAssignment(
        day: "Saturday",
        task: "Wheel Alignment",
        status: "waiting",
      ),
    ],
  ),
];
