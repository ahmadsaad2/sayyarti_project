import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> booking;

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
  late TextEditingController serviceController;

  @override
  void initState() {
    super.initState();

    // Initialize fields with booking data and provide default fallbacks
    status = widget.booking['status'] ?? 'Pending';
    paymentMethod = widget.booking['payment_method'] ?? 'Cash';

    nameController =
        TextEditingController(text: widget.booking['customer_name'] ?? '');
    mobileController =
        TextEditingController(text: widget.booking['mobile'] ?? '');
    dateController = TextEditingController(
        text: widget.booking['booking_date'] ?? '01/01/2025');
    timeController = TextEditingController(
        text: widget.booking['time'] ?? '10:00 AM'); // Default time
    serviceController =
        TextEditingController(text: widget.booking['service'] ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    mobileController.dispose();
    dateController.dispose();
    timeController.dispose();
    serviceController.dispose();
    super.dispose();
  }

  Future<void> _updateBooking() async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://192.168.88.4:5000/api/bookings/update-status/${widget.booking['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customer_name': nameController.text,
          'mobile': mobileController.text,
          'service': serviceController.text,
          'status': status,
          'payment_method': paymentMethod,
          'booking_date': dateController.text,
          'time': timeController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated successfully')),
        );
        Navigator.pop(context, json.decode(response.body)['booking']);
      } else {
        throw Exception('Failed to update booking');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating booking: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blue,
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
                labelText: 'Status',
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
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'Service',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Update Button
            ElevatedButton(
              onPressed: _updateBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Update Booking',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
