import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';
import 'package:sayyarti/screens/home/cart/CartPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> savedCart =
      []; // Variable to save cart data for database

  /// Calculates the total price based on unit price and quantity
  double calculateTotalPrice(double unitPrice, int quantity) {
    return unitPrice * quantity;
  }

  // Adds a product to the cart, saves the data, and logs it
  void addToCart(
      Map<String, dynamic> product, int quantity, double totalPrice) async {
    final prefs = await SharedPreferences.getInstance();
    final url =
        Uri.http(backendUrl, '/user/add-cart/${prefs.getInt('userId')}');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': prefs.getString('token')!,
      },
      body: json.encode({
        'part_id': product['id'],
        'quantity': quantity,
      }),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '${product['name']} x$quantity added to cart for \$${totalPrice.toStringAsFixed(2)}'),
        duration: const Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${product['name']} x$quantity added to cart for \$${totalPrice.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // Ensure price is treated as a double
    double price = double.tryParse(product['price'].toString()) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the Cart Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  product['image'],
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              product['name'] ?? 'Unknown Product',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Unit Price
            Text(
              'Unit Price: \$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22, color: Color.fromARGB(255, 29, 31, 139)),
            ),
            const SizedBox(height: 16),

            // Product Description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product['description'] ?? 'No description available.',
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 182, 122, 122)),
              ),
            ),
            const Divider(height: 32, thickness: 2),

            // Quantity Selector and Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Price: \$${calculateTotalPrice(price, quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 29, 31, 139),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                double totalPrice = calculateTotalPrice(price, quantity);
                addToCart(product, quantity, totalPrice);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '${product['name']} x$quantity added to cart for \$${totalPrice.toStringAsFixed(2)}'),
                  duration: const Duration(seconds: 2),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 7, 10, 163),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
