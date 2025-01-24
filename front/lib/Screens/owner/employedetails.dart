import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../class/employeclass.dart';
import '../class/work_assignment.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailsPage({super.key, required this.employee});

  @override
  EmployeeDetailsPageState createState() => EmployeeDetailsPageState();
}

class EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late List<WorkAssignment> workAssignments;

  @override
  void initState() {
    super.initState();
    // Initialize each day's assignment or create a blank one if none exist
    workAssignments = daysOfWeek.map((day) {
      return widget.employee.workAssignments.firstWhere(
        (assignment) => assignment.day == day,
        orElse: () => WorkAssignment(
          id: 0,
          day: day,
          task: '',
          worked: false,
        ),
      );
    }).toList();
  }

  // Send each assignment via PUT
  Future<void> _updateOrCreateAssignments() async {
    for (final assignment in workAssignments) {
      // If 'task' is empty, you might skip or handle differently
      // We'll update for all, even if task is blank
      try {
        final url = Uri.parse(
          'http://192.168.88.4:5000/api/workassignments/assign/'
          '${widget.employee.id}/${assignment.day}',
        );

        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'task': assignment.task,
            'worked': assignment.worked,
          }),
        );

        if (response.statusCode == 201) {
          debugPrint('Created assignment for ${assignment.day}');
        } else if (response.statusCode == 200) {
          debugPrint('Updated assignment for ${assignment.day}');
        } else {
          debugPrint(
            'Failed to upsert ${assignment.day}. Response: ${response.body}',
          );
        }
      } catch (e) {
        debugPrint('Error upserting assignment for ${assignment.day}: $e');
      }
    }
  }

  void _saveChanges() async {
    setState(() {
      widget.employee.workAssignments
        ..clear()
        ..addAll(workAssignments);
    });

    await _updateOrCreateAssignments();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assignments updated/created successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.employee.name} Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmployeeInfoCard(),
            Text(
              'Work Assignments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            _buildAssignmentsTable(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save & PUT Changes'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Attendance Calendar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ...workAssignments.map(_buildAttendanceCard),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(
          widget.employee.name.isNotEmpty ? widget.employee.name : 'No Name',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Position: ${widget.employee.position}'),
            Text('Contact: ${widget.employee.contact}'),
            Text('Email: ${widget.employee.email}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsTable() {
    return DataTable(
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('Day')),
        DataColumn(label: Text('Task')),
        DataColumn(label: Text('Worked?')),
      ],
      rows: workAssignments.map((workAssignment) {
        return DataRow(
          cells: [
            DataCell(Text(workAssignment.day)),
            DataCell(
              TextFormField(
                initialValue: workAssignment.task,
                onChanged: (value) {
                  setState(() {
                    workAssignment.task = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(
                  workAssignment.worked ? Icons.check_circle : Icons.cancel,
                  color: workAssignment.worked ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    workAssignment.worked = !workAssignment.worked;
                  });
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceCard(WorkAssignment workAssignment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        title: Text(workAssignment.day),
        subtitle: Text(workAssignment.worked ? 'Worked' : 'Did not work'),
        trailing: Icon(
          workAssignment.worked ? Icons.check_circle : Icons.cancel,
          color: workAssignment.worked ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
