import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Ensure this package is added to pubspec.yaml

class TowingServiceFormPage extends StatefulWidget {
  const TowingServiceFormPage({super.key});

  @override
  State<TowingServiceFormPage> createState() => _TowingServiceFormPageState();
}

class _TowingServiceFormPageState extends State<TowingServiceFormPage> {
  // Vehicle Information
  String selectedCarBrand = 'Toyota';
  final TextEditingController licensePlateController = TextEditingController();
  String selectedVehicleType = 'Car';
  String selectedVehicleCondition = 'Drivable';

  // Pickup Details
  final TextEditingController pickupAddressController = TextEditingController();
  LatLng? pickupLocation;
  final TextEditingController nearestLandmarkController =
      TextEditingController();

  // Drop-off Details
  final TextEditingController destinationAddressController =
      TextEditingController();
  String preferredDropOffPoint = 'Repair Shop';

  // Towing Type
  String selectedTowingType = 'Flatbed Tow';

  // Contact Information
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController alternativeContactController =
      TextEditingController();

  // Map Picker for Pickup Location
  void _showMapPicker(BuildContext context, bool isPickup) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick Location"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(32.2211, 35.2544), // Nablus, Palestine
                initialZoom: 13.0, // Adjust the zoom level as needed
                onTap: (tapPosition, point) {
                  setState(() {
                    if (isPickup) {
                      pickupLocation = point;
                    }
                  });
                  Navigator.pop(context); // Close the map dialog
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (isPickup && pickupLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: pickupLocation!,
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

  // Validate and Submit
  void _submitRequest(BuildContext context) {
    if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number.')),
      );
      return;
    }

    // Print all details in the terminal
    print('Car Brand: $selectedCarBrand');
    print('License Plate Number: ${licensePlateController.text}');
    print('Vehicle Type: $selectedVehicleType');
    print('Vehicle Condition: $selectedVehicleCondition');
    print('Pickup Address: ${pickupAddressController.text}');
    print(
        'Pickup Location: ${pickupLocation?.latitude}, ${pickupLocation?.longitude}');
    print('Nearest Landmark: ${nearestLandmarkController.text}');
    print('Destination Address: ${destinationAddressController.text}');
    print('Preferred Drop-off Point: $preferredDropOffPoint');
    print('Towing Type: $selectedTowingType');
    print('Customer Name: ${customerNameController.text}');
    print('Phone Number: ${phoneNumberController.text}');
    print('Alternative Contact: ${alternativeContactController.text}');

    // Navigate to confirmation page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TowingConfirmationPage(
          vehicleBrand: selectedCarBrand,
          licensePlate: licensePlateController.text,
          vehicleType: selectedVehicleType,
          vehicleCondition: selectedVehicleCondition,
          pickupAddress: pickupAddressController.text,
          pickupLocation: pickupLocation,
          nearestLandmark: nearestLandmarkController.text,
          destinationAddress: destinationAddressController.text,
          preferredDropOffPoint: preferredDropOffPoint,
          towingType: selectedTowingType,
          customerName: customerNameController.text,
          phoneNumber: phoneNumberController.text,
          alternativeContact: alternativeContactController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Towing Services"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Information
            const Text(
              "Vehicle Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCarBrand,
              decoration: InputDecoration(
                labelText: "Car Brand",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Toyota',
                'Kia',
                'BMW',
                'Mercedes-Benz',
                'Honda',
                'Ford',
                'Nissan',
                'Hyundai',
                'Chevrolet',
                'Audi',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCarBrand = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: licensePlateController,
              decoration: InputDecoration(
                labelText: "License Plate Number",
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
            DropdownButtonFormField<String>(
              value: selectedVehicleCondition,
              decoration: InputDecoration(
                labelText: "Vehicle Condition",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Drivable',
                'Non-drivable',
                'Accident-damaged',
                'Stuck (mud, sand)',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedVehicleCondition = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Pickup Details
            const Text(
              "Pickup Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: pickupAddressController,
              decoration: InputDecoration(
                labelText: "Current Location Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showMapPicker(context, true),
              child: const Text("Pick Location on Map"),
            ),
            if (pickupLocation != null)
              Text(
                'Selected Pickup Location: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}',
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

            // Drop-off Details
            const Text(
              "Drop-off Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: destinationAddressController,
              decoration: InputDecoration(
                labelText: "Destination Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: preferredDropOffPoint,
              decoration: InputDecoration(
                labelText: "Preferred Drop-off Point",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Repair Shop',
                'Home',
                'Gas Station',
                'Other',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  preferredDropOffPoint = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Towing Type
            const Text(
              "Towing Type",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTowingType,
              decoration: InputDecoration(
                labelText: "Service Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Flatbed Tow',
                'Wheel-Lift Tow',
                'Integrated Tow',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTowingType = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Contact Information
            const Text(
              "Contact Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: alternativeContactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Alternative Contact (Optional)",
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

class TowingConfirmationPage extends StatelessWidget {
  final String vehicleBrand;
  final String licensePlate;
  final String vehicleType;
  final String vehicleCondition;
  final String pickupAddress;
  final LatLng? pickupLocation;
  final String nearestLandmark;
  final String destinationAddress;
  final String preferredDropOffPoint;
  final String towingType;
  final String customerName;
  final String phoneNumber;
  final String alternativeContact;

  const TowingConfirmationPage({
    super.key,
    required this.vehicleBrand,
    required this.licensePlate,
    required this.vehicleType,
    required this.vehicleCondition,
    required this.pickupAddress,
    required this.pickupLocation,
    required this.nearestLandmark,
    required this.destinationAddress,
    required this.preferredDropOffPoint,
    required this.towingType,
    required this.customerName,
    required this.phoneNumber,
    required this.alternativeContact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Car Brand: $vehicleBrand"),
            Text("License Plate: $licensePlate"),
            Text("Vehicle Type: $vehicleType"),
            Text("Vehicle Condition: $vehicleCondition"),
            Text("Pickup Address: $pickupAddress"),
            if (pickupLocation != null)
              Text(
                  "Pickup Location: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}"),
            Text("Nearest Landmark: $nearestLandmark"),
            Text("Destination Address: $destinationAddress"),
            Text("Preferred Drop-off Point: $preferredDropOffPoint"),
            Text("Towing Type: $towingType"),
            Text("Customer Name: $customerName"),
            Text("Phone Number: $phoneNumber"),
            if (alternativeContact.isNotEmpty)
              Text("Alternative Contact: $alternativeContact"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order confirmed!'),
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
                  'Confirm Order',
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
