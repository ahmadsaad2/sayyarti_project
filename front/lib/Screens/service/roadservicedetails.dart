import 'package:flutter/material.dart';

class RoadServiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> service;

  const RoadServiceDetailsPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service['serviceName']),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Service image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  service['image'],
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Service name
            Text(
              service['serviceName'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Service rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '${service['rating']}',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Service description
            Text(
              service['description'],
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 182, 122, 122)),
            ),
            const Divider(height: 32, thickness: 2),

            // Service location
            const Text(
              'Location:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              service['location'],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),

            // People involved in the service
            const Text(
              'Service Providers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(service['people'].length, (index) {
                var person = service['people'][index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(person['image']),
                  ),
                  title: Text(person['name']),
                  subtitle: Text(person['location']),
                  trailing: Text(person['contact']),
                  onTap: () {
                    // You can handle the action when tapping on a service provider
                  },
                );
              }),
            ),
            const SizedBox(height: 32),

            // Request service button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${service['serviceName']} service requested'),
                  duration: const Duration(seconds: 2),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 10, 163),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Request Service',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
