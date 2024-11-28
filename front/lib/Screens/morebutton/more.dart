import 'package:flutter/material.dart';

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap; // Callback function for the button tap

  CustomButton({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Adjust shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image/Icon part of the button
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 30.0,
                width: 30.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10), // Space between image and title
            // Title of the button
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // You can change color as per need
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HomePage Widget with multiple custom buttons
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          CustomButton(
            title: "Button 1",
            imagePath:
                "assets/image1.png", // Replace with your actual image path
            onTap: () {
              // Action when Button 1 is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SomeNextPage()), // Change the page as needed
              );
            },
          ),
          const SizedBox(height: 20), // Space between buttons
          CustomButton(
            title: "Button 2",
            imagePath:
                "assets/image2.png", // Replace with your actual image path
            onTap: () {
              // Action when Button 2 is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AnotherPage()), // Change the page as needed
              );
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            title: "Button 3",
            imagePath:
                "assets/image3.png", // Replace with your actual image path
            onTap: () {
              // Action when Button 3 is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const YetAnotherPage()), // Change the page as needed
              );
            },
          ),
        ],
      ),
    );
  }
}

// Dummy pages for navigation demonstration
class SomeNextPage extends StatelessWidget {
  const SomeNextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Page")),
      body: const Center(child: Text("This is the next page!")),
    );
  }
}

class AnotherPage extends StatelessWidget {
  const AnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Another Page")),
      body: const Center(child: Text("This is another page!")),
    );
  }
}

class YetAnotherPage extends StatelessWidget {
  const YetAnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yet Another Page")),
      body: const Center(child: Text("This is yet another page!")),
    );
  }
}
