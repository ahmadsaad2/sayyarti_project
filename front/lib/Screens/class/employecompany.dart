import 'employeclass.dart';

class EmployeeCompany {
  final int id;
  final String name;
  final String address;
  final String email;
  final List<Employee> employees;

  EmployeeCompany({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.employees,
  });

  factory EmployeeCompany.fromJson(Map<String, dynamic> json) {
    final employeesJson = json['employees'] as List<dynamic>? ?? [];
    return EmployeeCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      employees: employeesJson
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'employees': employees.map((emp) => emp.toJson()).toList(),
    };
  }
}
