import 'package:flutter/material.dart';

class WorkshopDetailsPage extends StatelessWidget {
  final Map<String, dynamic> workshop;

  const WorkshopDetailsPage({Key? key, required this.workshop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workshop['name'] ?? 'Workshop Name'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Workshop Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  workshop['image'] ??
                      'assets/images/default.jpg', // Default fallback image
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Workshop Name
            Text(
              workshop['name'] ?? 'Default Name', // Null-safe fallback
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Workshop Location
            Text(
              workshop['location'] ?? 'Unknown Location', // Fallback location
              style: const TextStyle(
                  fontSize: 22, color: Color.fromARGB(255, 29, 31, 139)),
            ),
            const SizedBox(height: 16),

            // Workshop Details
            Text(
              workshop['details'] ??
                  'No details available', // Null-safe fallback
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 182, 122, 122)),
            ),
            const SizedBox(height: 16),

            // Rating
            Text(
              'Rating: ${workshop['rating'] ?? 'N/A'}', // Null-safe fallback
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 29, 31, 139)),
            ),
            const Divider(height: 32, thickness: 2),

            // Buttons for Booking and Messaging
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Book Now Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('${workshop['name']} booked successfully!'),
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
                      'Book Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between buttons

                // Send Message Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Message sent to ${workshop['name']}'),
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
                      'Send Message',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
