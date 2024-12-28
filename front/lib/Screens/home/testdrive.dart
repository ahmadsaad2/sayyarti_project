import 'package:flutter/material.dart';
import 'bookingpagetestdrive.dart';

class TestDriveSection extends StatelessWidget {
  const TestDriveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to the Test Drive page (optional)
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/solution-1.jpg', // Adjust your asset path
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to booking page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 29, 68, 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 16, // Adjust font size for better fit
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 212, 217, 236),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
