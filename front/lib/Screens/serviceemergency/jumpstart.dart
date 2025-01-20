import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../model/assistancerequest.dart'; // Import the AssistanceRequest model

class JumpStartAssistancePage extends StatefulWidget {
  const JumpStartAssistancePage({super.key});

  @override
  State<JumpStartAssistancePage> createState() =>
      _JumpStartAssistancePageState();
}

class _JumpStartAssistancePageState extends State<JumpStartAssistancePage> {
  // Vehicle Details
  final TextEditingController vehicleMakeModelController =
      TextEditingController();
  String selectedVehicleType = 'Car';
  final TextEditingController batteryTypeController = TextEditingController();

  // Problem Description
  String selectedIssue = 'Battery completely dead';
  final TextEditingController additionalNotesController =
      TextEditingController();

  // Location Details
  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController nearestLandmarkController =
      TextEditingController();
  LatLng? selectedLocation;

  // Assistance Options
  bool immediateAssistance = true;
  DateTime scheduledTime = DateTime.now();
  bool replaceBattery = false;
  bool diagnoseIssues = false;

  // Contact Details
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Map Picker for Location
  void _showMapPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pin Your Location"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(32.2211, 35.2544), // Default location
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedLocation = point;
                  });
                  Navigator.pop(context); // Close the map dialog
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedLocation!,
                        child:
                            const Icon(Icons.location_pin, color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitRequest(BuildContext context) {
    if (vehicleMakeModelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your vehicle make and model.')),
      );
      return;
    }

    // Create an AssistanceRequest object
    AssistanceRequest request = AssistanceRequest(
      userId: 1, // Replace with actual user ID
      serviceType: "Jump Start", // Hardcoded service type
      requestDate: DateTime.now(), // Current date and time
      vehicleMakeModel: vehicleMakeModelController.text,
      vehicleType: selectedVehicleType,
      batteryType: batteryTypeController.text,
      issueDescription: selectedIssue,
      additionalNotes: additionalNotesController.text,
      currentLocationAddress: currentLocationController.text,
      nearestLandmark: nearestLandmarkController.text,
      latitude: selectedLocation?.latitude,
      longitude: selectedLocation?.longitude,
      immediateAssistance: immediateAssistance,
      scheduledTime: immediateAssistance ? null : scheduledTime,
      customerName: nameController.text,
      phoneNumber: phoneController.text,
      alternativeContact: emailController.text,
    );

    // Print the request data to the debug console
    print('Confirmed Order Data:');
    print(request.toJson());

    // Add the request to the list
    AssistanceRequest().addRequest(request);

    // Print all requests for debugging
    AssistanceRequest().printAllRequests();

    // Navigate to confirmation page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JumpStartConfirmationPage(
          vehicleMakeModel: vehicleMakeModelController.text,
          vehicleType: selectedVehicleType,
          batteryType: batteryTypeController.text,
          issue: selectedIssue,
          additionalNotes: additionalNotesController.text,
          currentLocation: currentLocationController.text,
          nearestLandmark: nearestLandmarkController.text,
          selectedLocation: selectedLocation,
          immediateAssistance: immediateAssistance,
          scheduledTime: immediateAssistance ? null : scheduledTime,
          replaceBattery: replaceBattery,
          diagnoseIssues: diagnoseIssues,
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jump Start Assistance"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              "Jump Start Assistance",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Get help with jump-starting your vehicle anytime, anywhere.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Vehicle Details
            const Text(
              "Vehicle Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: vehicleMakeModelController,
              decoration: InputDecoration(
                labelText: "Vehicle Make and Model",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedVehicleType,
              decoration: InputDecoration(
                labelText: "Vehicle Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: ['Car', 'SUV', 'Truck', 'Motorcycle']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedVehicleType = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: batteryTypeController,
              decoration: InputDecoration(
                labelText: "Battery Type (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Problem Description
            const Text(
              "Problem Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedIssue,
              decoration: InputDecoration(
                labelText: "Issue with the Vehicle",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Battery completely dead',
                'Vehicle won\'t start but lights are working',
                'Vehicle won\'t start and no lights are working',
                'Unknown issue',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedIssue = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: additionalNotesController,
              decoration: InputDecoration(
                labelText: "Additional Notes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Location Details
            const Text(
              "Location Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: currentLocationController,
              decoration: InputDecoration(
                labelText: "Current Location Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showMapPicker(context),
              child: const Text("Pin Location on Map"),
            ),
            if (selectedLocation != null)
              Text(
                'Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nearestLandmarkController,
              decoration: InputDecoration(
                labelText: "Nearest Landmark (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Assistance Options
            const Text(
              "Assistance Options",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Immediate Assistance"),
              value: immediateAssistance,
              onChanged: (bool value) {
                setState(() {
                  immediateAssistance = value;
                });
              },
            ),
            if (!immediateAssistance) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: scheduledTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != scheduledTime) {
                    setState(() {
                      scheduledTime = picked;
                    });
                  }
                },
                child: Text(
                  'Scheduled Time: ${scheduledTime.toLocal()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text("Check and replace battery if needed"),
              value: replaceBattery,
              onChanged: (bool? value) {
                setState(() {
                  replaceBattery = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Diagnose other possible issues"),
              value: diagnoseIssues,
              onChanged: (bool? value) {
                setState(() {
                  diagnoseIssues = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Contact Details
            const Text(
              "Contact Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () => _submitRequest(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 54, 8, 182),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JumpStartConfirmationPage extends StatelessWidget {
  final String vehicleMakeModel;
  final String vehicleType;
  final String batteryType;
  final String issue;
  final String additionalNotes;
  final String currentLocation;
  final String nearestLandmark;
  final LatLng? selectedLocation;
  final bool immediateAssistance;
  final DateTime? scheduledTime;
  final bool replaceBattery;
  final bool diagnoseIssues;
  final String name;
  final String phone;
  final String email;

  const JumpStartConfirmationPage({
    super.key,
    required this.vehicleMakeModel,
    required this.vehicleType,
    required this.batteryType,
    required this.issue,
    required this.additionalNotes,
    required this.currentLocation,
    required this.nearestLandmark,
    required this.selectedLocation,
    required this.immediateAssistance,
    required this.scheduledTime,
    required this.replaceBattery,
    required this.diagnoseIssues,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmation"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Vehicle Make and Model: $vehicleMakeModel"),
            Text("Vehicle Type: $vehicleType"),
            Text("Battery Type: $batteryType"),
            Text("Issue: $issue"),
            Text("Additional Notes: $additionalNotes"),
            Text("Current Location: $currentLocation"),
            Text("Nearest Landmark: $nearestLandmark"),
            if (selectedLocation != null)
              Text(
                  "Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}"),
            Text(
                "Assistance Type: ${immediateAssistance ? 'Immediate' : 'Scheduled'}"),
            if (!immediateAssistance) Text("Scheduled Time: $scheduledTime"),
            Text("Replace Battery: ${replaceBattery ? 'Yes' : 'No'}"),
            Text("Diagnose Issues: ${diagnoseIssues ? 'Yes' : 'No'}"),
            Text("Name: $name"),
            Text("Phone: $phone"),
            Text("Email: $email"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Request submitted successfully!'),
                    ),
                  );
                  Navigator.pop(context); // Go back to the previous page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 54, 8, 182),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Confirm Request',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
