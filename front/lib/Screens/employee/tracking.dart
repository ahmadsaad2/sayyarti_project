import 'package:flutter/material.dart';

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

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Default tracking steps
  List<TrackingStep> defaultTrackingSteps = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Order Status'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: defaultTrackingSteps.length,
              itemBuilder: (context, index) {
                return _buildTrackingStepCard(
                    defaultTrackingSteps[index], index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStepCard(TrackingStep step, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              // If a step is marked as completed, ensure all previous steps are also completed
              if (step.isCompleted) {
                for (int i = 0; i <= index; i++) {
                  defaultTrackingSteps[i].isCompleted = true;
                }
              } else {
                // If a step is unmarked, ensure all subsequent steps are also unmarked
                for (int i = index; i < defaultTrackingSteps.length; i++) {
                  defaultTrackingSteps[i].isCompleted = false;
                }
              }
            });
          },
          activeColor: Colors.blueAccent,
        ),
      ),
    );
  }

  void _saveChanges() {
    // Simulate saving changes (e.g., send to backend)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order status updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: OrdersPage(),
  ));
}
