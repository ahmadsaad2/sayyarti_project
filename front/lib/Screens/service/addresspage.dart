import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Street Text Field
            _buildTextField(
              label: 'Street Address',
              controller: _streetController,
            ),
            const SizedBox(height: 16),

            // City Text Field
            _buildTextField(
              label: 'City',
              controller: _cityController,
            ),
            const SizedBox(height: 16),

            // State Text Field
            _buildTextField(
              label: 'State',
              controller: _stateController,
            ),
            const SizedBox(height: 16),

            // Zip Code Text Field
            _buildTextField(
              label: 'Zip Code',
              controller: _zipCodeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address added successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Optionally print the entered data
                  print("Street: ${_streetController.text}");
                  print("City: ${_cityController.text}");
                  print("State: ${_stateController.text}");
                  print("Zip Code: ${_zipCodeController.text}");
                },
                style: ElevatedButton.styleFrom(
                    // primary: Colors.blue, // Button color
                    // onPrimary: Colors.white, // Text color
                    ),
                child: const Text('Save Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        filled: true,
        fillColor: Colors.grey[200], // Background color of the text field
      ),
    );
  }
}
