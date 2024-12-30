import 'package:flutter/material.dart';
import 'CheckoutPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /// Dummy data for the cart items
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Brake Pads',
      'price': 25.0,
      'quantity': 1,
      'totalPrice': 25.0,
      'image': 'assets/images/brake_pads.jpg',
      'description': 'Durable brake pads for various car models.',
    },
    {
      'name': 'Engine Oil',
      'price': 40.0,
      'quantity': 2,
      'totalPrice': 80.0,
      'image': 'assets/images/engine_oil.jpg',
      'description': 'High-performance synthetic engine oil.',
    },
  ];

  /// Calculates the total price for all items in the cart.
  double calculateCartTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item['totalPrice']);
  }

  /// Deletes an item from the cart by index.
  void deleteCartItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Dismissible(
                        key: Key(item['name']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          // Delete the item when swiped
                          deleteCartItem(index);

                          // Show a snackbar notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${item['name']} removed from cart.'),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.asset(
                              item['image'],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unit Price: \$${item['price'].toStringAsFixed(2)}',
                                ),
                                Text('Quantity: ${item['quantity']}'),
                              ],
                            ),
                            trailing: Text(
                              '\$${item['totalPrice'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${calculateCartTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty
                        ? null // Disable button if cart is empty
                        : () {
                            // Navigate to the Checkout Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  total: calculateCartTotal(),
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cartItems.isEmpty
                          ? Colors.grey // Disabled color
                          : const Color.fromARGB(255, 7, 10, 163),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
