import 'package:flutter/material.dart';
import '../../service/addcar.dart'; // Import the AddCarPage

class MyCarsPage extends StatelessWidget {
  MyCarsPage({super.key});

  final List<Map<String, String>> cars = [
    {'title': 'Car 1', 'model': '2022', 'subtitle': 'Model: 2022'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of cars
            Expanded(
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  // Access each car's details dynamically
                  final car = cars[index];
                  return ListTile(
                    title: Text(car['title'] ?? 'No Title'),
                    subtitle: Text(car['subtitle'] ?? 'No Subtitle'),
                    leading: const Icon(Icons.home), // Change to home icon
                    trailing: Text(car['model'] ?? 'No Model'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Add Car Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Add Car Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCarPage()),
                  );
                },
                child: const Text('Add Car'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
