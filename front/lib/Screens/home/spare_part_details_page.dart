import 'package:flutter/material.dart';

class SparePartDetailsPage extends StatelessWidget {
  final Map<String, String> orderDetails;

  const SparePartDetailsPage({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  orderDetails['title'] ?? 'Order Details',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Order Information
                _buildSectionHeader('Order Information'),
                _buildDetailRow('Garage', orderDetails['garageName'] ?? 'N/A'),
                _buildDetailRow('Type', orderDetails['type'] ?? 'N/A'),
                _buildDetailRow('Status', orderDetails['status'] ?? 'N/A'),
                _buildDetailRow('Date', orderDetails['date'] ?? 'N/A'),

                const SizedBox(height: 16),

                // Customer Information
                _buildSectionHeader('Customer Information'),
                _buildDetailRow(
                    'Customer Name', orderDetails['customerName'] ?? 'N/A'),
                _buildDetailRow(
                    'Phone Number', orderDetails['phoneNumber'] ?? 'N/A'),

                const SizedBox(height: 16),

                // Problem Details
                _buildSectionHeader('Problem Details'),
                _buildDetailRow(
                    'Problem', orderDetails['problemDetails'] ?? 'N/A'),
                _buildDetailRow(
                    'Preferred Time', orderDetails['preferredTime'] ?? 'N/A'),
                _buildDetailRow('Method', orderDetails['method'] ?? 'N/A'),

                const SizedBox(height: 16),

                // Attachments
                _buildSectionHeader('Attachments'),
                _buildDetailRow('Problem Image/Video',
                    orderDetails['problemImageOrVideo'] ?? 'Not attached'),
                _buildDetailRow('Car License',
                    orderDetails['carLicense'] ?? 'Not attached'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
