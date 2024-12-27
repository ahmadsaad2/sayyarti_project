import 'package:flutter/material.dart';
import '../class/employeclass.dart';
import '../class/work_assignment.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailsPage({Key? key, required this.employee})
      : super(key: key);

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  late List<WorkAssignment> workAssignments;

  @override
  void initState() {
    super.initState();

    // Initialize work assignments with existing data or empty tasks
    workAssignments = daysOfWeek.map((day) {
      return widget.employee.workAssignments.firstWhere(
        (assignment) => assignment.day == day,
        orElse: () => WorkAssignment(day: day, task: '', worked: false),
      );
    }).toList();
  }

  void _saveChanges() {
    setState(() {
      widget.employee.workAssignments = workAssignments;
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Work assignments updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.employee.name} Details'),
      ),
      body: ListView(
        children: [
          // Employee Info
          ListTile(
            title: Text('Name: ${widget.employee.name}'),
            subtitle: Text('Position: ${widget.employee.position}'),
          ),
          ListTile(
            title: Text('Contact: ${widget.employee.contact}'),
          ),

          // Work Assignments Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Work Assignments',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Updated from headline6 to titleLarge
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Day')),
              DataColumn(label: Text('Task')),
              DataColumn(label: Text('Worked?')),
            ],
            rows: List.generate(
              daysOfWeek.length,
              (index) {
                final day = daysOfWeek[index];
                final workAssignment = workAssignments[index];

                return DataRow(
                  cells: [
                    DataCell(Text(day)),
                    DataCell(
                      TextFormField(
                        initialValue: workAssignment.task,
                        onChanged: (value) {
                          setState(() {
                            workAssignment.task = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              workAssignment.worked
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: workAssignment.worked
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                workAssignment.worked = !workAssignment.worked;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ),

          // Attendance Calendar Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Attendance Calendar',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Updated from headline6 to titleLarge
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daysOfWeek.length,
            itemBuilder: (context, index) {
              final day = daysOfWeek[index];
              final attendance = workAssignments[index].worked;

              return ListTile(
                title: Text(day),
                subtitle: Text(attendance ? 'Worked' : 'Did not work'),
                trailing: Icon(
                  attendance ? Icons.check_circle : Icons.cancel,
                  color: attendance ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
