// lib/pages/employee_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';
import '../class/employeclass.dart';
import '../class/task.dart'; // Import the Task class
import 'task_details_page.dart';
import 'task_in_progress_page.dart';

import './profileemployee.dart'; // Import the EditEmployeePage widget
import 'package:http/http.dart' as http;
import './work_assignement_tabel.dart ';

class EmployeePage extends StatefulWidget {
  final int userId; // Accept the userId as a parameter
  const EmployeePage({super.key, required this.userId});

  @override
  EmployeePageState createState() => EmployeePageState();
}

class EmployeePageState extends State<EmployeePage> {
  late Future<Employee> _employeeFuture;
  final List<String> notifications = [
    "Task assigned: Car Wash at 10:00 AM",
    "Task completed: Polishing at 12:00 PM",
  ];

  DateTime? selectedDate;
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    super.initState();
    _employeeFuture = _fetchEmployeeData(widget.userId);
  }

  Future<Employee> _fetchEmployeeData(int userId) async {
    try {
      final url = Uri.http(backendUrl, '/api/employee/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Employee.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Employee not found');
      } else {
        throw Exception('Failed to load employee data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Could not reach the server');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  _showNotifications();
                },
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${notifications.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: FutureBuilder<Employee>(
        future: _employeeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Drawer(
              child: Center(
                child: Text(
                  snapshot.error.toString().contains('Employee not found')
                      ? 'Employee not found'
                      : 'Error: ${snapshot.error}',
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Drawer(
              child: Center(child: Text('No employee data found')),
            );
          } else {
            final employee = snapshot.data!;
            return _buildDrawer(employee);
          }
        },
      ),
      body: FutureBuilder<Employee>(
        future: _employeeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString().contains('Employee not found')
                    ? 'Employee not found'
                    : 'Error: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No employee data found'));
          } else {
            final employee = snapshot.data!;
            return _buildBody(employee);
          }
        },
      ),
    );
  }

  Widget _buildBody(Employee employee) {
    final String selectedDay = (selectedDate != null)
        ? daysOfWeek[(selectedDate!.weekday - 1) % 7]
        : daysOfWeek[(DateTime.now().weekday - 1) % 7];

    final incompleteTasks = employee.tasks
        .where((task) => task.status == "waiting" && task.day == selectedDay)
        .toList();
    final inProgressTasks = employee.tasks
        .where(
            (task) => task.status == "In Progress" && task.day == selectedDay)
        .toList();
    final completedTasks = employee.tasks
        .where((task) => task.status == "Complete" && task.day == selectedDay)
        .toList();

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Today's Assignments",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            "Selected Day: $selectedDay",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        _buildTaskSection("Waiting Tasks", incompleteTasks),
        _buildTaskSection("In Progress Tasks", inProgressTasks),
        _buildTaskSection("Completed Tasks", completedTasks),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Work Assignments",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        WorkAssignmentTable(workAssignments: employee.workAssignments),
      ],
    );
  }

  Widget _buildDrawer(Employee employee) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/5.jpg'),
                ),
                const SizedBox(height: 10),
                Text(
                  employee.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  employee.role,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tasks'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEmployeePage(employee: employee),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => _buildTaskCard(task)).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    if (task.status == "waiting") {
      return _buildIncompleteTaskCard(task);
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.task),
        subtitle: Text("Day: ${task.day}"),
        onTap: () {
          if (task.status == "Complete") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsPage(task: task),
              ),
            );
          } else if (task.status == "In Progress") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskInProgressPage(task: task),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildIncompleteTaskCard(Task task) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.task),
        subtitle: Text("Day: ${task.day}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                // Update task status to "In Progress"
                _updateTaskStatus(task, "In Progress");
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                // Update task status to "Declined"
                _updateTaskStatus(task, "Declined");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTaskStatus(Task task, String newStatus) async {
    try {
      // final url = Uri.http(backendUrl, '/auth/signin');
      final response = await http.put(
        Uri.http(backendUrl, '/api/employee/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          task.status = newStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task status updated to $newStatus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: $error')),
      );
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notifications"),
          content: notifications.isEmpty
              ? const Text("No notifications available.")
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(notifications[index]),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
