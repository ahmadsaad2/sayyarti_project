import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Ensure this package is added to pubspec.yaml

class FuelDeliveryPage extends StatefulWidget {
  const FuelDeliveryPage({super.key});

  @override
  State<FuelDeliveryPage> createState() => _FuelDeliveryPageState();
}

class _FuelDeliveryPageState extends State<FuelDeliveryPage> {
  String selectedCarType = 'Sedan'; // Changed to car type
  String selectedFuelType = 'Petrol';
  double fuelQuantity = 10.0; // Default fuel quantity in liters
  DateTime selectedTime = DateTime.now();
  DateTime selectedDate = DateTime.now(); // Added for date selection
  TextEditingController locationController = TextEditingController();
  TextEditingController nearestLocationController =
      TextEditingController(); // Added for nearest location
  TextEditingController phoneNumberController =
      TextEditingController(); // Added for phone number validation
  LatLng? selectedLocation;
  double pricePerLiter = 2.0; // Example price per liter
  double totalPrice = 0.0; // Added for total price calculation

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
    );
    if (picked != null && picked != TimeOfDay.fromDateTime(selectedTime)) {
      setState(() {
        selectedTime = DateTime(
          selectedTime.year,
          selectedTime.month,
          selectedTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
                    selectedLocation = point;
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

  void _calculateTotalPrice() {
    setState(() {
      totalPrice = fuelQuantity * pricePerLiter;
    });
  }

  void _navigateToOrderConfirmation(BuildContext context) {
    if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(
          carType: selectedCarType,
          fuelType: selectedFuelType,
          fuelQuantity: fuelQuantity,
          totalPrice: totalPrice,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          nearestLocation: nearestLocationController.text,
          selectedLocation: selectedLocation,
          phoneNumber: phoneNumberController.text,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice(); // Initialize total price
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Delivery"),
        backgroundColor: const Color.fromARGB(255, 46, 1, 150),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fue2l.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Service Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Emergency Fuel Delivery",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Get fuel delivered to your location anytime, anywhere!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select the Type of Car:", // Changed to "Select the Type of Car"
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedCarType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCarType = newValue!;
                      });
                    },
                    items: <String>['Sedan', 'SUV', 'Truck']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Fuel Type:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedFuelType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFuelType = newValue!;
                      });
                    },
                    items: <String>['Petrol', 'Diesel', 'Electric']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Fuel Quantity (Liters):",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: fuelQuantity,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: fuelQuantity.toString(),
                    onChanged: (double value) {
                      setState(() {
                        fuelQuantity = value;
                        _calculateTotalPrice();
                      });
                    },
                  ),
                  Text(
                    'Selected Quantity: ${fuelQuantity.toStringAsFixed(1)} liters',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Price: \${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Delivery Date:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Text(
                      '${selectedDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Delivery Time:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _selectTime(context),
                    child: Text(
                      '${selectedTime.hour}:${selectedTime.minute}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pick Your Location:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showMapPicker(context),
                    child: const Text("Pick Location on Map"),
                  ),
                  if (selectedLocation != null)
                    Text(
                      'Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Write the Nearest Location to You:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nearestLocationController,
                    decoration: InputDecoration(
                      hintText: 'Enter the nearest location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter Your Phone Number:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _navigateToOrderConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 54, 8, 182),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  final String carType;
  final String fuelType;
  final double fuelQuantity;
  final double totalPrice;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final String nearestLocation;
  final LatLng? selectedLocation;
  final String phoneNumber;

  const OrderConfirmationPage({
    super.key,
    required this.carType,
    required this.fuelType,
    required this.fuelQuantity,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.nearestLocation,
    required this.selectedLocation,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Print details in the terminal
    print('Car Type: $carType');
    print('Fuel Type: $fuelType');
    print('Fuel Quantity: $fuelQuantity liters');
    print('Total Price: \$${totalPrice.toStringAsFixed(2)}');
    print('Selected Date: ${selectedDate.toLocal()}');
    print('Selected Time: ${selectedTime.hour}:${selectedTime.minute}');
    print('Nearest Location: $nearestLocation');
    print(
        'Selected Location: ${selectedLocation?.latitude}, ${selectedLocation?.longitude}');
    print('Phone Number: $phoneNumber');

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
            Text("Car Type: $carType"),
            Text("Fuel Type: $fuelType"),
            Text("Fuel Quantity: $fuelQuantity liters"),
            Text("Total Price: \$${totalPrice.toStringAsFixed(2)}"),
            Text("Selected Date: ${selectedDate.toLocal()}"),
            Text("Selected Time: ${selectedTime.hour}:${selectedTime.minute}"),
            Text("Nearest Location: $nearestLocation"),
            if (selectedLocation != null)
              Text(
                  "Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}"),
            Text("Phone Number: $phoneNumber"),
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
