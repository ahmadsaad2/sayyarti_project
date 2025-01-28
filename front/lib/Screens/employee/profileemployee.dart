// lib/pages/edit_employee_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/constants.dart';
import 'dart:convert';
import '../class/employeclass.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;

  const EditEmployeePage({super.key, required this.employee});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _emailController = TextEditingController(text: widget.employee.email ?? '');
    _contactController =
        TextEditingController(text: widget.employee.contact ?? '');
  }

  Future<void> _updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.put(
          Uri.http(backendUrl, '/api/employee/${widget.employee.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _nameController.text,
            'email': _emailController.text,
            'contact': _contactController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['employee'] != null) {
            final updatedEmployee = Employee.fromJson(responseData['employee']);
            setState(() {
              widget.employee.name = updatedEmployee.name;
              widget.employee.email = updatedEmployee.email;
              widget.employee.contact = updatedEmployee.contact;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee updated successfully')),
            );
          }
        } else {
          // Handle server errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update employee: ${response.body}')),
          );
        }
      } catch (error) {
        // Handle network or parsing errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Employee'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the email';
                          }
                          // Simple email validation
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(labelText: 'Contact'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the contact number';
                          }
                          // Simple contact number validation (optional)
                          if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
                            return 'Please enter a valid contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateEmployee,
                        child: const Text('Update'),
                      ),
                    ]),
                  ),
                ),
        ));
  }
}
