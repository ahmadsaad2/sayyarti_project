import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../class/employeclass.dart';
import '../class/task.dart';
import 'task_details_page.dart'; // Import the TaskDetailsPage
import './profileemployee.dart';
import 'package:http/http.dart' as http;
import './work_assignement_tabel.dart';

class EmployeePage extends StatefulWidget {
  final int userId; // Accept the userId as a parameter
  const EmployeePage({super.key, required this.userId});

  @override
  EmployeePageState createState() => EmployeePageState();
}

class EmployeePageState extends State<EmployeePage> {
  late Future<Employee> _employeeFuture;
  List<Task> tasks = [];
  String? selectedDay;
  String? selectedStatus;

  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final List<String> statuses = ["All", "waiting", "In Progress", "Complete"];

  @override
  void initState() {
    super.initState();
    _employeeFuture = _fetchEmployeeData(widget.userId);
    _fetchTasks(); // Fetch tasks when the page loads
  }

  Future<Employee> _fetchEmployeeData(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.88.4:5000/api/employee/$userId'),
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

  Future<void> _fetchTasks() async {
    try {
      final uri = Uri.parse(
        'http://192.168.88.4:5000/api/tasks/by-user/${widget.userId}',
      ).replace(queryParameters: {
        if (selectedDay != null) 'day': selectedDay,
        if (selectedStatus != null && selectedStatus != "All")
          'status': selectedStatus,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          tasks = (json.decode(response.body) as List)
              .map((data) => Task.fromJson(data))
              .toList();
        });
      } else if (response.statusCode == 404) {
        setState(() {
          tasks = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tasks found')),
        );
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $error')),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDay,
                onChanged: (value) {
                  setState(() {
                    selectedDay = value;
                  });
                },
                items: daysOfWeek
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Select Day',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                items: statuses
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Select Status',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _fetchTasks(); // Fetch tasks with the new filter
                Navigator.pop(context);
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _buildTaskSection("Waiting Tasks",
                  tasks.where((task) => task.status == "waiting").toList()),
              _buildTaskSection("In Progress Tasks",
                  tasks.where((task) => task.status == "In Progress").toList()),
              _buildTaskSection("Completed Tasks",
                  tasks.where((task) => task.status == "Complete").toList()),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Work Assignments",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              WorkAssignmentTable(workAssignments: employee.workAssignments),
            ],
          ),
        ),
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
          ...tasks.map((task) => _buildTaskCard(task)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          task.task,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Day: ${task.day}"),
            Text("Status: ${task.status}"),
          ],
        ),
        trailing: Icon(
          task.status == "Complete"
              ? Icons.check_circle
              : task.status == "In Progress"
                  ? Icons.access_time
                  : Icons.pending,
          color: task.status == "Complete"
              ? Colors.green
              : task.status == "In Progress"
                  ? Colors.orange
                  : Colors.red,
        ),
        onTap: () {
          // Navigate to TaskDetailsPage when the task card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(task: task),
            ),
          ).then((_) {
            // Refresh the task list after returning from TaskDetailsPage
            _fetchTasks();
          });
        },
      ),
    );
  }
}
