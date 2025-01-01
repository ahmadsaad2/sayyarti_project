import 'employeclass.dart';

class Car {
  final String id;
  final String model;
  Employee? assignedEmployee;

  Car({
    required this.id,
    required this.model,
    this.assignedEmployee,
  });

  void assignEmployee(Employee employee) {
    assignedEmployee = employee;
  }

  void removeAssignedEmployee() {
    assignedEmployee = null;
  }
}
