import 'package:flutter/material.dart';

import 'orderpage.dart';

class ServiceDetailsPage extends StatefulWidget {
  final Map<String, String> orderDetails;
  final List<TrackingStep> trackingSteps;

  const ServiceDetailsPage({
    super.key,
    required this.orderDetails,
    required this.trackingSteps,
  });

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late List<TrackingStep> trackingSteps;

  @override
  void initState() {
    super.initState();
    trackingSteps = widget.trackingSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Details Card
            _buildOrderDetailsCard(),

            const SizedBox(height: 20),

            // Tracking Updates Section
            _buildTrackingUpdates(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    return Card(
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
              widget.orderDetails['title'] ?? 'Order Details',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Order Information'),
            _buildDetailRow(
                'Garage', widget.orderDetails['garageName'] ?? 'N/A'),
            _buildDetailRow('Type', widget.orderDetails['type'] ?? 'N/A'),
            _buildDetailRow('Status', widget.orderDetails['status'] ?? 'N/A'),
            _buildDetailRow('Date', widget.orderDetails['date'] ?? 'N/A'),

            const SizedBox(height: 16),

            // Customer Information
            _buildSectionHeader('Customer Information'),
            _buildDetailRow(
                'Customer Name', widget.orderDetails['customerName'] ?? 'N/A'),
            _buildDetailRow(
                'Phone Number', widget.orderDetails['phoneNumber'] ?? 'N/A'),

            const SizedBox(height: 16),

            // Problem Details
            _buildSectionHeader('Problem Details'),
            _buildDetailRow(
                'Problem', widget.orderDetails['problemDetails'] ?? 'N/A'),
            _buildDetailRow('Preferred Time',
                widget.orderDetails['preferredTime'] ?? 'N/A'),
            _buildDetailRow('Method', widget.orderDetails['method'] ?? 'N/A'),

            const SizedBox(height: 16),

            // Attachments
            _buildSectionHeader('Attachments'),
            _buildDetailRow('Problem Image/Video',
                widget.orderDetails['problemImageOrVideo'] ?? 'Not attached'),
            _buildDetailRow('Car License',
                widget.orderDetails['carLicense'] ?? 'Not attached'),
          ],
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

  Widget _buildTrackingUpdates() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Updates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),

            // Vertical Timeline
            Column(
              children: trackingSteps
                  .map((step) => _buildTrackingStep(step))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(TrackingStep step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: step.isCompleted ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: step.isCompleted ? Colors.green : Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.step,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: step.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
              Text(
                step.description,
                style: TextStyle(
                  color: step.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
