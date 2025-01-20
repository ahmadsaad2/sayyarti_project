import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Ensure this package is added to pubspec.yaml
import '../../model/assistancerequest.dart'; // Import the AssistanceRequestModel class

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
  final int userId; // Required
  final String customerName; // Required
  final Function(AssistanceRequest) onConfirmOrder;

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
    required this.userId, // Required
    required this.customerName, // Required
    required this.onConfirmOrder,
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
                  // Create an AssistanceRequest object
                  AssistanceRequest request = AssistanceRequest(
                    userId: userId,
                    serviceType: "Fuel Delivery",
                    requestDate: DateTime.now(),
                    vehicleMakeModel: carType,
                    vehicleType: carType,
                    currentLocationAddress: nearestLocation,
                    immediateAssistance: true,
                    customerName: customerName,
                    phoneNumber: phoneNumber,
                    fuelType: fuelType,
                    fuelQuantity: fuelQuantity,
                    totalPrice: totalPrice,
                    latitude: selectedLocation?.latitude,
                    longitude: selectedLocation?.longitude,
                    nearestLandmark: nearestLocation,
                  );

                  // Call the callback to add the request
                  onConfirmOrder(request);

                  // Print the confirmed order data
                  print('Confirmed Order Data:');
                  print(request.toJson());

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
