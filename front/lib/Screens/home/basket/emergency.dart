import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import '../../../model/assistancerequest.dart';

class AssistanceRequestDetailsPage extends StatefulWidget {
  final AssistanceRequest request;

  const AssistanceRequestDetailsPage({
    super.key,
    required this.request,
  });

  @override
  _AssistanceRequestDetailsPageState createState() =>
      _AssistanceRequestDetailsPageState();
}

class _AssistanceRequestDetailsPageState
    extends State<AssistanceRequestDetailsPage> {
  late LatLng _location;

  @override
  void initState() {
    super.initState();
    // Initialize the location using latitude and longitude from the request
    _location = LatLng(
      widget.request.latitude ?? 0.0,
      widget.request.longitude ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistance Request Details'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Details Card
            _buildRequestDetailsCard(),

            const SizedBox(height: 20),

            // Map Section
            _buildMapSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestDetailsCard() {
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
              'Assistance Request Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Service Information
            _buildSectionHeader('Service Information'),
            _buildDetailRow(
                'Service Type', widget.request.serviceType ?? 'N/A'),
            _buildDetailRow('Request Date',
                widget.request.requestDate?.toString() ?? 'N/A'),
            _buildDetailRow(
                'Vehicle Make/Model', widget.request.vehicleMakeModel ?? 'N/A'),
            _buildDetailRow(
                'Vehicle Type', widget.request.vehicleType ?? 'N/A'),
            _buildDetailRow(
                'License Plate', widget.request.licensePlate ?? 'N/A'),
            _buildDetailRow(
                'Vehicle Condition', widget.request.vehicleCondition ?? 'N/A'),

            const SizedBox(height: 16),

            // Location Details
            _buildSectionHeader('Location Details'),
            _buildDetailRow('Current Location',
                widget.request.currentLocationAddress ?? 'N/A'),
            _buildDetailRow(
                'Nearest Landmark', widget.request.nearestLandmark ?? 'N/A'),
            _buildDetailRow(
                'Latitude', widget.request.latitude?.toString() ?? 'N/A'),
            _buildDetailRow(
                'Longitude', widget.request.longitude?.toString() ?? 'N/A'),

            const SizedBox(height: 16),

            // Contact Information
            _buildSectionHeader('Contact Information'),
            _buildDetailRow(
                'Customer Name', widget.request.customerName ?? 'N/A'),
            _buildDetailRow(
                'Phone Number', widget.request.phoneNumber ?? 'N/A'),
            _buildDetailRow('Alternative Contact',
                widget.request.alternativeContact ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
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
              'Location on Map',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300, // Set a fixed height for the map
              child: FlutterMap(
                options: MapOptions(
                  initialCenter:
                      _location, // Center the map on the provided location
                  initialZoom: 13.0, // Set the initial zoom level
                ),
                children: [
                  // Tile Layer (OpenStreetMap)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  // Marker for the location
                  MarkerLayer(
                    markers: [
                      Marker(
                        point:
                            _location, // LatLng object for the marker's location
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
}
