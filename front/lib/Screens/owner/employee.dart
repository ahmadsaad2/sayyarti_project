// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  // Sample list of employees (replace with your actual data source)
  List<Map<String, String>> employees = [
    {'name': 'John Doe', 'role': 'Mechanic', 'contact': '123-456-789'},
    {'name': 'Jane Smith', 'role': 'Service Advisor', 'contact': '987-654-321'},
  ];

  void _addEmployee() {
    // Open a dialog or new page to add an employee
    // For simplicity, here we just add a dummy employee
    setState(() {
      employees.add({
        'name': 'New Employee',
        'role': 'Technician',
        'contact': '555-555-555',
      });
    });
  }

  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
  }

  void _editEmployee(int index) {
    // Open a dialog to edit the employee details (simplified)
    showDialog(
      context: context,
      builder: (context) {
        String name = employees[index]['name']!;
        String role = employees[index]['role']!;
        String contact = employees[index]['contact']!;

        return AlertDialog(
          title: const Text('Edit Employee'),
          content: Column(
            children: [
              TextFormField(
                initialValue: name,
                onChanged: (value) {
                  name = value;
                },
                decoration: const InputDecoration(labelText: 'Employee Name'),
              ),
              TextFormField(
                initialValue: role,
                onChanged: (value) {
                  role = value;
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                initialValue: contact,
                onChanged: (value) {
                  contact = value;
                },
                decoration: const InputDecoration(labelText: 'Contact'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  employees[index] = {
                    'name': name,
                    'role': role,
                    'contact': contact
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Management')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text(employee['name']!),
            subtitle: Text(
                'Role: ${employee['role']} - Contact: ${employee['contact']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteEmployee(index),
            ),
            onTap: () => _editEmployee(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        child: const Icon(Icons.add),
      ),
    );
  }
}
