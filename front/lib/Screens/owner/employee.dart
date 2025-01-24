import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'employeform.dart';
import '../class/employeclass.dart';
import './employedetails.dart';

class EmployeePage extends StatefulWidget {
  final int companyId; // ID of the company

  const EmployeePage({super.key, required this.companyId});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<Employee> employees = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployees(); // Fetch employees on page load
  }

  /// Fetch employees for the given company ID
  Future<void> _fetchEmployees() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.88.4:5000/api/employees/company/${widget.companyId}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['employees'] as List;
        setState(() {
          employees = data.map((e) => Employee.fromJson(e)).toList();
        });
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching employees: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Add a new employee
  Future<void> _addEmployee() async {
    final newEmployee = await Navigator.push<Employee?>(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeForm(companyId: widget.companyId),
      ),
    );

    if (newEmployee != null) {
      // Refresh employees after adding a new one
      _fetchEmployees();
    }
  }

  /// View employee details
  void _viewEmployeeDetails(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employee: employee),
      ),
    );
  }

  /// Delete an employee
  Future<void> _deleteEmployee(int employeeId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.88.4:5000/api/employees/$employeeId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          employees.removeWhere((employee) => employee.id == employeeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee deleted!')),
        );
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting employee: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEmployee,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
              ? const Center(child: Text('No employees found!'))
              : ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Dismissible(
                      key: Key(employee.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteEmployee(employee.id!);
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          title: Text(employee.name ?? 'Unknown Name'),
                          onTap: () => _viewEmployeeDetails(employee),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
