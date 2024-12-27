import 'package:flutter/material.dart';

import '../class/work_assignment.dart';

class IncompleteTaskPage extends StatelessWidget {
  final WorkAssignment task;

  const IncompleteTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incomplete Task'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildIncompleteTaskCard(task),
        ),
      ),
    );
  }

  Widget _buildIncompleteTaskCard(WorkAssignment task) {
    return Card(
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
                // Handle accept logic
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
                // Handle decline logic
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
    );
  }
}
