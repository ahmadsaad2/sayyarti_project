// this page for employee management
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'employeform.dart';
import 'employedetails.dart';
import '../class/employeclass.dart';
import '../class/car.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final List<Employee> employees = [];
  final List<Car> cars = [
    Car(id: '1', model: 'Toyota Camry'),
    Car(id: '2', model: 'BMW X5'),
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  /// Load employees from SharedPreferences
  Future<void> _loadEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeList = prefs.getStringList('employees') ?? [];
    setState(() {
      employees.clear();
      for (var employeeJson in employeeList) {
        final employeeMap = jsonDecode(employeeJson);
        employees.add(Employee(
          name: employeeMap['name'],
          email: employeeMap['email'],
          position: employeeMap['position'],
          contact: employeeMap['contact'],
          workAssignments: [], // Load assignments if stored
        ));
      }
    });
  }

  /// Save employees to SharedPreferences
  Future<void> _saveEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeList = employees
        .map((employee) => jsonEncode({
              'name': employee.name,
              'email': employee.email,
              'position': employee.position,
              'contact': employee.contact,
            }))
        .toList();
    await prefs.setStringList('employees', employeeList);
  }

  /// Show a SnackBar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Add a new employee
  void _addEmployee() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Add New Employee')),
          body: EmployeeForm(
            onSaveComplete: () async {
              await _loadEmployees(); // Refresh the employee list
              await _saveEmployees(); // Persist data
              _showSnackBar('Employee added successfully!');
              Navigator.pop(context); // Return to the previous page
            },
          ),
        ),
      ),
    );
  }

  /// Edit an existing employee
  void _editEmployee(int index) {
    final employee = employees[index]; // Get the employee to edit

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Employee'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: EmployeeForm(
                name: employee.name,
                email: employee.email,
                position: employee.position,
                contact: employee.contact,
                onSaveComplete: () async {
                  await _loadEmployees(); // Refresh the list
                  await _saveEmployees(); // Persist data
                  _showSnackBar('Employee updated successfully!');
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Delete an employee
  void _deleteEmployee(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: const Text('Are you sure you want to delete this employee?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  employees.removeAt(index);
                });
                await _saveEmployees(); // Persist data
                _showSnackBar('Employee deleted successfully!');
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Assign work to an employee
  void _assignWork(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Work to Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a car to assign work:'),
              ...cars.map((car) {
                return ListTile(
                  title: Text(car.model),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        car.assignEmployee(employees[index]);
                      });
                      Navigator.of(context).pop();
                      _showSnackBar(
                          '${car.model} assigned to ${employees[index].name}!');
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  /// View detailed employee information
  void _viewEmployeeDetails(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employee: employee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEmployee,
          ),
        ],
      ),
      body: employees.isEmpty
          ? const Center(child: Text('No employees added yet!'))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: ListTile(
                    title: Text(employees[index].name),
                    subtitle: Text('Position: ${employees[index].position}'),
                    onTap: () => _viewEmployeeDetails(employees[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editEmployee(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteEmployee(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.work),
                          onPressed: () => _assignWork(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
