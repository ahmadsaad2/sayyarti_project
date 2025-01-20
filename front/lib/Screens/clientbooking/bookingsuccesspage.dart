import 'package:flutter/material.dart';

class BookingSuccessPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingSuccessPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustration/Image Section
            SizedBox(
              height: 200,
              child: Image.asset(
                'assets/images/booked.JPG', // Add a relevant image
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            // Success Message
            const Text(
              'Booked Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Details Section
            Text(
              "Hey ${bookingData['customerName'] ?? 'Unknown'}, you have booked ${bookingData['selectedService'] ?? 'a service'} successfully.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 8),

            Text(
              "Date & Time: ${bookingData['preferredDate']?.toLocal().toString().split(' ')[0] ?? 'N/A'} | ${bookingData['preferredTime'] ?? 'N/A'}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 8),

            const Text(
              "We have sent your booking information to your email.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 32),

            // Button Section
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(200, 50), // Button size
              ),
              onPressed: () {
                int counter = 0;
                Navigator.popUntil(context, (route) {
                  counter++;
                  // Stop popping when the third page from the bottom is reached
                  return counter == 6;
                });
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
