import 'package:flutter/material.dart';
import '../../service/addresspage.dart'; // Import the Add Address Page

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Address (If any)
            ListTile(
              title: const Text('User Address'),
              subtitle: const Text('1234 Main St, Springfield, IL 62701'),
              leading: const Icon(Icons.home), // Home icon
              trailing: const Text('Default'),
            ),
            const SizedBox(height: 20),

            // Add Address Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Add Address Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAddressPage()),
                  );
                },
                child: const Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
