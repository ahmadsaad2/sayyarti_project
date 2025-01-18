import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Ensure this package is added to pubspec.yaml

class TireProblemPage extends StatefulWidget {
  const TireProblemPage({super.key});

  @override
  State<TireProblemPage> createState() => _TireProblemPageState();
}

class _TireProblemPageState extends State<TireProblemPage> {
  // Tire Problem Details
  String selectedTireProblem = 'Flat tire';
  String selectedNumberOfTires = 'Single tire';

  // Vehicle Information
  final TextEditingController vehicleMakeModelController =
      TextEditingController();
  String selectedVehicleType = 'Car';
  String spareTireAvailability = 'Yes';
  final TextEditingController toolsAvailableController =
      TextEditingController();

  // Service Options
  String selectedService = 'On-site tire repair';

  // Pickup Location
  final TextEditingController pickupAddressController = TextEditingController();
  LatLng? pickupLocation;
  final TextEditingController nearestLandmarkController =
      TextEditingController();
  String roadsideDetails = 'On highway';

  // Schedule and Time
  bool immediateAssistance = true;
  DateTime selectedTime = DateTime.now();

  // Map Picker for Pickup Location
  void _showMapPicker(BuildContext context) {
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
                    pickupLocation = point;
                  });
                  Navigator.pop(context); // Close the map dialog
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (pickupLocation != null)
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
    if (vehicleMakeModelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your vehicle make and model.')),
      );
      return;
    }

    // Print all details in the terminal
    print('Tire Problem: $selectedTireProblem');
    print('Number of Tires Affected: $selectedNumberOfTires');
    print('Vehicle Make and Model: ${vehicleMakeModelController.text}');
    print('Vehicle Type: $selectedVehicleType');
    print('Spare Tire Availability: $spareTireAvailability');
    print('Tools Available: ${toolsAvailableController.text}');
    print('Requested Service: $selectedService');
    print('Pickup Address: ${pickupAddressController.text}');
    print(
        'Pickup Location: ${pickupLocation?.latitude}, ${pickupLocation?.longitude}');
    print('Nearest Landmark: ${nearestLandmarkController.text}');
    print('Roadside Details: $roadsideDetails');
    print('Immediate Assistance: $immediateAssistance');
    if (!immediateAssistance) {
      print('Scheduled Time: $selectedTime');
    }

    // Navigate to confirmation page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TireProblemConfirmationPage(
          tireProblem: selectedTireProblem,
          numberOfTires: selectedNumberOfTires,
          vehicleMakeModel: vehicleMakeModelController.text,
          vehicleType: selectedVehicleType,
          spareTireAvailability: spareTireAvailability,
          toolsAvailable: toolsAvailableController.text,
          requestedService: selectedService,
          pickupAddress: pickupAddressController.text,
          pickupLocation: pickupLocation,
          nearestLandmark: nearestLandmarkController.text,
          roadsideDetails: roadsideDetails,
          immediateAssistance: immediateAssistance,
          scheduledTime: immediateAssistance ? null : selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tire Problem Assistance"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tire Problem Details
            const Text(
              "Tire Problem Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedTireProblem,
              decoration: InputDecoration(
                labelText: "Type of Problem",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Flat tire',
                'Tire burst',
                'Slow air leak',
                'Tire misalignment',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTireProblem = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedNumberOfTires,
              decoration: InputDecoration(
                labelText: "Number of Tires Affected",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'Single tire',
                'Multiple tires',
                'All tires',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedNumberOfTires = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Vehicle Information
            const Text(
              "Vehicle Information",
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
            DropdownButtonFormField<String>(
              value: spareTireAvailability,
              decoration: InputDecoration(
                labelText: "Spare Tire Availability",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items:
                  ['Yes', 'No'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  spareTireAvailability = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: toolsAvailableController,
              decoration: InputDecoration(
                labelText: "Tools Available in Vehicle",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Options
            const Text(
              "Service Options",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Requested Service",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  isEmpty: selectedService == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded:
                          true, // Expands the dropdown to avoid clipping
                      value: selectedService,
                      items: [
                        'On-site tire repair',
                        'Tire replacement',
                        'Air pressure refill',
                        'Emergency towing to the nearest repair shop',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow
                                .fade, // Fade overflow text gracefully
                            softWrap: false, // Avoid text wrapping in dropdown
                            maxLines: 1, // Ensure a single line
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService = newValue!;
                          state.didChange(
                              newValue); // Inform the FormField of changes
                        });
                      },
                    ),
                  ),
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a service option.';
                }
                return null;
              },
              initialValue: selectedService,
            ),

            const SizedBox(height: 20),

            // Pickup Location
            const Text(
              "Pickup Location",
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
              onPressed: () => _showMapPicker(context),
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
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: roadsideDetails,
              decoration: InputDecoration(
                labelText: "Roadside Details",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: [
                'On highway',
                'Main road',
                'Remote area',
                'Parking lot or garage',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  roadsideDetails = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Schedule and Time
            const Text(
              "Schedule and Time",
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
                    initialDate: selectedTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: Text(
                  'Scheduled Time: ${selectedTime.toLocal()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
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

class TireProblemConfirmationPage extends StatelessWidget {
  final String tireProblem;
  final String numberOfTires;
  final String vehicleMakeModel;
  final String vehicleType;
  final String spareTireAvailability;
  final String toolsAvailable;
  final String requestedService;
  final String pickupAddress;
  final LatLng? pickupLocation;
  final String nearestLandmark;
  final String roadsideDetails;
  final bool immediateAssistance;
  final DateTime? scheduledTime;

  const TireProblemConfirmationPage({
    super.key,
    required this.tireProblem,
    required this.numberOfTires,
    required this.vehicleMakeModel,
    required this.vehicleType,
    required this.spareTireAvailability,
    required this.toolsAvailable,
    required this.requestedService,
    required this.pickupAddress,
    required this.pickupLocation,
    required this.nearestLandmark,
    required this.roadsideDetails,
    required this.immediateAssistance,
    required this.scheduledTime,
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
            Text("Tire Problem: $tireProblem"),
            Text("Number of Tires Affected: $numberOfTires"),
            Text("Vehicle Make and Model: $vehicleMakeModel"),
            Text("Vehicle Type: $vehicleType"),
            Text("Spare Tire Availability: $spareTireAvailability"),
            Text("Tools Available: $toolsAvailable"),
            Text("Requested Service: $requestedService"),
            Text("Pickup Address: $pickupAddress"),
            if (pickupLocation != null)
              Text(
                  "Pickup Location: ${pickupLocation!.latitude}, ${pickupLocation!.longitude}"),
            Text("Nearest Landmark: $nearestLandmark"),
            Text("Roadside Details: $roadsideDetails"),
            Text("Immediate Assistance: ${immediateAssistance ? 'Yes' : 'No'}"),
            if (!immediateAssistance) Text("Scheduled Time: $scheduledTime"),
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
