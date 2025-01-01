import 'package:flutter/material.dart';

class OfferDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedOffers;

  const OfferDetailsPage({Key? key, required this.selectedOffers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Offers'),
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
                const Text(
                  'Selected Offers',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Iterate through the list of maps
                for (var offerMap in selectedOffers)
                  for (var offerKey in offerMap.keys)
                    _buildOfferDetails(offerKey, offerMap[offerKey]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferDetails(
      String offerKey, Map<String, dynamic> offerDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.grey),
        Text(
          offerDetails['description'] ?? 'Offer Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Type', offerDetails['Type'] ?? 'N/A'),
        _buildDetailRow('Amount', offerDetails['Amount'] ?? 'N/A'),
        _buildDetailRow('Minimum Spend', '\$${offerDetails['Minimum']}'),
        _buildDetailRow('Start Date', offerDetails['Start'] ?? 'N/A'),
        _buildDetailRow('End Date', offerDetails['End'] ?? 'N/A'),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
