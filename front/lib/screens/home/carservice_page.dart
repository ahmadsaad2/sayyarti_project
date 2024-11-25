import 'package:flutter/material.dart';

class CarServicePage extends StatelessWidget {
  const CarServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Service"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Available Services",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  // Service 1: Oil Change
                  _buildServiceBox(
                    title: "Oil Change",
                    description:
                        "Professional oil change to keep your car running smoothly.",
                    imagePath: "../../../assets/images/oil_change.jpg",
                  ),
                  const SizedBox(height: 16.0),
                  // Service 2: Tire Service
                  _buildServiceBox(
                    title: "Tire Service",
                    description:
                        "Tire rotation, repair, and replacement services.",
                    imagePath: "../../../assets/images/tire_service.jpg",
                  ),
                  const SizedBox(height: 16.0),
                  // Service 3: Brake Inspection
                  _buildServiceBox(
                    title: "Brake Inspection",
                    description:
                        "Ensure your safety with our detailed brake inspection.",
                    imagePath: "../../../assets/images/brake_service.jpg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBox({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        // Implement service-specific action here
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
