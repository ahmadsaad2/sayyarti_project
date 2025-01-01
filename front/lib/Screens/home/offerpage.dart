import 'package:flutter/material.dart';
import '../class/offermanager.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final offersManager = OffersManager.instance;

  // Map to store selected offers
  final Map<String, Map<String, String>> selectedOffers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Offers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offer Image
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/offer.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Offer Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Discover exclusive deals and discounts on your car!",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Offers:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Offer Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offersManager.offers.length,
                itemBuilder: (context, index) {
                  final offer = offersManager.offers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        offer["description"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${offer["Type"]}"),
                          Text("Amount: ${offer["Amount"]}"),
                          Text("Minimum Spend: \$${offer["Minimum"]}"),
                          Text("Valid: ${offer["Start"]} to ${offer["End"]}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          // Show confirmation dialog
                          _showConfirmationDialog(context, offer);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Show the saved offers at the bottom
            if (selectedOffers.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Selected Offers:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedOffers.length,
                itemBuilder: (context, index) {
                  final offer = selectedOffers.values.elementAt(index);
                  return ListTile(
                    title: Text(offer["description"]!),
                    subtitle: Text("Amount: ${offer["Amount"]}"),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Show confirmation dialog
  void _showConfirmationDialog(
      BuildContext context, Map<String, String> offer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Claim Offer"),
          content: Text(
              "Are you sure you want to claim the offer '${offer["description"]}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                // Add offer to selectedOffers
                setState(() {
                  selectedOffers[offer["description"]!] = offer;
                });

                // Print the offer to console
                print("Selected Offers: $selectedOffers");

                Navigator.pop(context); // Close the dialog

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${offer["description"]} added to cart!'),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
