import 'package:flutter/material.dart';
import '../class/task.dart'; // Import the Task class

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController _detailsController;
  late String _selectedStatus;

  // List of available task statuses
  final List<String> statuses = ["Waiting", "In Progress", "Complete"];

  // Default tracking steps
  final List<TrackingStep> defaultTrackingSteps = [
    TrackingStep(
      step: 'Waiting for approval of the request',
      description: 'Your request is waiting for approval.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Waiting for receipt',
      description: 'We are waiting to receive your car.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'The car has been delivered',
      description: 'Your car has been delivered to the garage.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Try the inspection and diagnosis',
      description: 'Inspection and diagnosis are in progress.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Work in progress',
      description: 'Repair work is currently in progress.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Testing the quality of the repair',
      description: 'We are testing the quality of the repair.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'Your car is ready for receipt',
      description: 'Your car is ready for you to pick up.',
      isCompleted: false,
    ),
    TrackingStep(
      step: 'The task is complete',
      description: 'The repair task is complete.',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController(text: widget.task.details);

    // Validate the status value
    _selectedStatus = statuses.contains(widget.task.status)
        ? widget.task.status
        : statuses.first;
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  // Function to save changes
  void _saveChanges() {
    setState(() {
      widget.task.details = _detailsController.text.trim();
      widget.task.status = _selectedStatus;
      widget.task.updatedAt = DateTime.now(); // Update the timestamp
    });

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task updated successfully!')),
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name
            Text(
              widget.task.task,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Task Day
            Text(
              'Day: ${widget.task.day}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Display Task Details (ID, Price, Time)
            Text(
              'Task ID: ${widget.task.id}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Task Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
              items: statuses
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Task Details Text Field
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Task Details',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Tracking Steps Section
            const Text(
              'Tracking Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...defaultTrackingSteps
                .map((step) => _buildTrackingStepCard(step))
                .toList(),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build a tracking step card
  Widget _buildTrackingStepCard(TrackingStep step) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          step.step,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: step.isCompleted ? Colors.green : Colors.black,
          ),
        ),
        subtitle: Text(
          step.description,
          style: TextStyle(
            fontSize: 14,
            color: step.isCompleted ? Colors.green : Colors.grey[600],
          ),
        ),
        trailing: Checkbox(
          value: step.isCompleted,
          onChanged: (bool? value) {
            setState(() {
              step.isCompleted = value ?? false;
            });
          },
          activeColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

class TrackingStep {
  final String step;
  final String description;
  bool isCompleted;

  TrackingStep({
    required this.step,
    required this.description,
    required this.isCompleted,
  });
}
