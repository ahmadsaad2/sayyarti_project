import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Success'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Image
            Center(
              child: Image.asset(
                'assets/images/8.jpg', // Replace with your success image path
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),

            // Success Message
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            const Text(
              'Thank you for your purchase. Your order is being processed.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Go to Home Button
            ElevatedButton(
              onPressed: () {
                int counter = 0;
                Navigator.popUntil(context, (route) {
                  counter++;
                  // Stop popping when the third page from the bottom is reached
                  return counter == 4;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 10, 163),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
