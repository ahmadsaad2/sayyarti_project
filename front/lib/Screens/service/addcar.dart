import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  // Controllers for car details input
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  var logger = Logger();
  @override
  void dispose() {
    // Dispose the controllers when no longer needed
    _carNameController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Car Name Text Field
            _buildTextField(
              label: 'Car Name',
              controller: _carNameController,
            ),
            const SizedBox(height: 16),

            // Car Model Text Field
            _buildTextField(
              label: 'Car Model',
              controller: _carModelController,
            ),
            const SizedBox(height: 16),

            // Car Year Text Field
            _buildTextField(
              label: 'Car Year',
              controller: _carYearController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action and show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Car added successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Optionally, print the saved car data
                  logger.i("Car Name: ${_carNameController.text}");
                  logger.i("Car Model: ${_carModelController.text}");
                  logger.i("Car Year: ${_carYearController.text}");
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the text fields
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
