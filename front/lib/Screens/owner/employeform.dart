import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeForm extends StatefulWidget {
  final void Function() onSaveComplete; // Callback to refresh employee list
  final String? name; // Optional field for name
  final String? email; // Optional field for email
  final String? position; // Optional field for position
  final String? contact; // Optional field for contact
  final String? password; // Optional field for password

  const EmployeeForm({
    super.key,
    required this.onSaveComplete,
    this.name,
    this.email,
    this.position,
    this.contact,
    this.password,
  });

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _positionController;
  late TextEditingController _contactController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with passed values or empty strings
    _nameController = TextEditingController(text: widget.name ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _positionController = TextEditingController(text: widget.position ?? '');
    _contactController = TextEditingController(text: widget.contact ?? '');
    _passwordController = TextEditingController(text: widget.password ?? '');
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      // Gather employee data
      final newEmployee = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'position': _positionController.text.trim(),
        'contact': _contactController.text.trim(),
        'password': _passwordController.text.trim(), // Save the password
      };

      // Save the employee data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> employeeList =
          prefs.getStringList('employees') ?? []; // Get existing employees

      // Add or update employee
      if (widget.name == null) {
        // Adding new employee
        employeeList.add(jsonEncode(newEmployee));
      } else {
        // Editing existing employee
        final index = employeeList.indexWhere((employee) {
          final employeeMap = jsonDecode(employee);
          return employeeMap['name'] == widget.name;
        });
        if (index != -1) {
          employeeList[index] = jsonEncode(newEmployee);
        }
      }

      await prefs.setStringList('employees', employeeList);

      // Call callback to refresh employee list
      widget.onSaveComplete();

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee saved successfully!')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Employee Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter employee name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true, // Mask the password input
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _positionController,
            decoration: const InputDecoration(labelText: 'Position'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter position';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _contactController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveEmployee,
            child: const Text('Save Employee'),
          ),
        ],
      ),
    );
  }
}
