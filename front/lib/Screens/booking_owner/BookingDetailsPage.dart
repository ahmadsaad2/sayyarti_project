import 'package:flutter/material.dart';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, String> booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late String status;
  late String paymentMethod;

  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController vehicleController;
  late TextEditingController amountController;
  late TextEditingController serviceController;

  @override
  void initState() {
    super.initState();

    // Initialize fields with booking data and provide default fallbacks
    status = ['Pending', 'Complete', 'Waiting', 'In Processing']
            .contains(widget.booking['Status'])
        ? widget.booking['Status']!
        : 'Pending';

    paymentMethod = ['Cash', 'Visa'].contains(widget.booking['Payment'])
        ? widget.booking['Payment']!
        : 'Cash';

    nameController =
        TextEditingController(text: widget.booking['Customer'] ?? '');
    mobileController =
        TextEditingController(text: widget.booking['Mobile'] ?? '');
    dateController = TextEditingController(text: '01/04/2024'); // Default
    timeController = TextEditingController(text: '01:21 PM'); // Default
    vehicleController = TextEditingController(text: 'Toyota Prius'); // Default
    amountController = TextEditingController(text: '542'); // Default
    serviceController =
        TextEditingController(text: widget.booking['Service'] ?? '');
  }

  @override
  void dispose() {
    // Dispose of controllers
    nameController.dispose();
    mobileController.dispose();
    dateController.dispose();
    timeController.dispose();
    vehicleController.dispose();
    amountController.dispose();
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking Details'),
        backgroundColor: const Color.fromARGB(255, 8, 28, 143),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: status,
              onChanged: (newValue) {
                setState(() {
                  status = newValue!;
                });
              },
              items: ['Pending', 'Complete', 'Waiting', 'In Processing']
                  .map((statusValue) => DropdownMenuItem(
                        value: statusValue,
                        child: Text(statusValue),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Booking Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Dropdown
            DropdownButtonFormField<String>(
              value: paymentMethod,
              onChanged: (newValue) {
                setState(() {
                  paymentMethod = newValue!;
                });
              },
              items: ['Cash', 'Visa']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Customer Details
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: mobileController,
              decoration: const InputDecoration(
                labelText: 'Customer Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Booking Details
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: vehicleController,
              decoration: const InputDecoration(
                labelText: 'Vehicle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Service Details
            TextFormField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'Service',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Update Button
            ElevatedButton(
              onPressed: () {
                // Create an updated booking map
                final updatedBooking = {
                  'Customer': nameController.text,
                  'Mobile': mobileController.text,
                  'Service': serviceController.text,
                  'Payment': paymentMethod,
                  'Status': status,
                };

                // Return updated booking to the previous page
                Navigator.pop(context, updatedBooking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Update', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
