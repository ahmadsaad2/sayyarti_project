import 'package:flutter/material.dart';

import 'BookingDetailsPage.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final List<Map<String, String>> bookings = [
    {
      "Customer": "John Doe",
      "Mobile": "1234567890",
      "Service": "Car Wash",
      "Time": "10:00 AM",
      "Payment": "Paid",
      "Status": "Pending"
    },
    {
      "Customer": "Jane Smith",
      "Mobile": "0987654321",
      "Service": "Polishing",
      "Time": "12:00 PM",
      "Payment": "Pending",
      "Status": "Waiting"
    },
  ];

  void _deleteBooking(int index) {
    setState(() {
      bookings.removeAt(index);
    });
  }

  void _editBooking(int index) async {
    final updatedBooking = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsPage(booking: bookings[index]),
      ),
    );

    if (updatedBooking != null) {
      setState(() {
        bookings[index] = updatedBooking;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: Text('Service')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Payment')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: bookings.asMap().entries.map(
              (entry) {
                final index = entry.key;
                final booking = entry.value;

                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(booking['Customer'] ?? '')),
                    DataCell(Text(booking['Mobile'] ?? '')),
                    DataCell(Text(booking['Service'] ?? '')),
                    DataCell(Text(booking['Time'] ?? '')),
                    DataCell(Text(booking['Payment'] ?? '')),
                    DataCell(Text(booking['Status'] ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editBooking(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteBooking(index),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
