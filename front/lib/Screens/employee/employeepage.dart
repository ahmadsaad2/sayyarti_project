import 'package:flutter/material.dart';
import '../class/employeclass.dart';

import '../class/work_assignment.dart';
import 'task_details_page.dart';
import 'task_in_progress_page.dart';
import 'profileemployee.dart';

class EmployeePage extends StatefulWidget {
  final Employee employee; // Accept Employee object
  const EmployeePage({super.key, required this.employee});

  @override
  EmployeePageState createState() => EmployeePageState();
}

class EmployeePageState extends State<EmployeePage> {
  final List<String> notifications = [
    "Task assigned: Car Wash at 10:00 AM",
    "Task completed: Polishing at 12:00 PM",
  ];

  DateTime? selectedDate; // Store the selected date

  // Map DateTime.weekday to day names
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
  Widget build(BuildContext context) {
    // Determine the day name from the selected date or today's date
    final String selectedDay = (selectedDate != null)
        ? daysOfWeek[(selectedDate!.weekday - 1) % 7]
        : daysOfWeek[(DateTime.now().weekday - 1) % 7];

    // Filter tasks for the selected day
    final filteredAssignments = widget.employee.workAssignments
        .where((assignment) => assignment.day == selectedDay)
        .toList();

    // Divide tasks into categories
    final incompleteTasks = filteredAssignments
        .where((assignment) => assignment.status == "waiting")
        .toList();
    final inProgressTasks = filteredAssignments
        .where((assignment) => assignment.status == "In Progress")
        .toList();
    final completedTasks = filteredAssignments
        .where((assignment) => assignment.status == "Complete")
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              // Show calendar to pick a date
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate; // Update selected date
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
      drawer: _buildDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Today's Assignments",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Selected Day: $selectedDay",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTaskSection("waiting Tasks", incompleteTasks),
                _buildTaskSection("In Progress Tasks", inProgressTasks),
                _buildTaskSection("Completed Tasks", completedTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncompleteTaskCard(WorkAssignment task) {
    return MouseRegion(
      onEnter: (_) {
        // Add logic if needed when mouse enters
      },
      onExit: (_) {
        // Add logic if needed when mouse exits
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(task.task),
          subtitle: Text("Day: ${task.day}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    task.status = "In Progress";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task marked as In Progress")),
                  );
                },
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, size: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    task.status = "Declined";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Task marked as Declined")),
                  );
                },
                child: const CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
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
                  widget.employee.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  widget.employee.position,
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
                  builder: (context) => ProfilePage(employee: widget.employee),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(String title, List<WorkAssignment> tasks) {
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

  Widget _buildTaskCard(WorkAssignment task) {
    if (task.status == "waiting") {
      return _buildIncompleteTaskCard(
          task); // Call the widget for waiting tasks
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
          title: Text(task.task),
          subtitle: Text("Day: ${task.day}"),
          onTap: () {
            // Navigate to different pages based on the task status
            if (task.status == "Complete") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                      assignment: task), // Page for completed tasks
                ),
              );
            } else if (task.status == "In Progress") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskInProgressPage(
                      assignment: task), // Page for in-progress tasks
                ),
              );
            }
          }),
    );
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
