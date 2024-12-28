import 'package:flutter/material.dart';

class BasketPage extends StatelessWidget {
  // Mock booking data
  final List<Map<String, dynamic>> bookings = [
    {
      'customerName': 'John Doe',
      'service': 'Oil Change',
      'garageName': 'ABC Garage',
      'date': '2023-12-30',
      'time': '10:00 AM',
      'status': 'Pending',
    },
    {
      'customerName': 'Jane Smith',
      'service': 'Tire Replacement',
      'garageName': 'XYZ Garage',
      'date': '2024-01-02',
      'time': '2:00 PM',
      'status': 'Completed',
    },
    {
      'customerName': 'Sam Wilson',
      'service': 'Brake Inspection',
      'garageName': 'Elite Garage',
      'date': '2024-01-05',
      'time': '1:00 PM',
      'status': 'In Progress',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Basket'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(booking: booking);
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking['service'] ?? 'Unknown Service',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Garage: ${booking['garageName'] ?? 'Unknown Garage'}'),
            Text('Customer: ${booking['customerName'] ?? 'Unknown Customer'}'),
            Text('Date: ${booking['date'] ?? 'Unknown Date'}'),
            Text('Time: ${booking['time'] ?? 'Unknown Time'}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${booking['status'] ?? 'Unknown Status'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(booking['status'] ?? 'Unknown'),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    // Add remove booking logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed booking: ${booking['service']}'),
                      ),
                    );
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Determine the status color based on the booking status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
