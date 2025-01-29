import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';

import 'CheckoutPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Dummy data for the cart items
  List<Map<String, dynamic>> cartItems = [];
  var _fetching = false;

  void _fetchCartData() async {
    setState(() {
      _fetching = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final url =
          Uri.http(backendUrl, '/user/get-cart/${prefs.getInt('userId')}');
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': prefs.getString('token')!,
        },
      );
      if (res.statusCode == 200) {
        List<dynamic> resData = json.decode(res.body);
        List<Map<String, dynamic>> updatedCartItems = resData.map((item) {
          return {
            'id': int.tryParse(item['id'].toString()),
            'name': item['name'],
            'price': double.tryParse(item['price'].toString()) ?? 0.0,
            'quantity': item['quantity'],
            'totalPrice': double.tryParse(item['totalPrice'].toString()) ?? 0.0,
            'image': item['image'],
            'description': item['description'],
          };
        }).toList();

        setState(() {
          cartItems = updatedCartItems;
          _fetching = false;
        });
      }
    } catch (e) {
      setState(() {
        cartItems = [];
        _fetching = false;
      });
      print('error  $e');
    }
  }

  /// Calculates the total price for all items in the cart.
  double calculateCartTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item['totalPrice']);
  }

  /// Deletes an item from the cart by index.
  void deleteCartItem(int index) async {
    final itemId = cartItems[index]['id'];
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.http(backendUrl, '/user/delete-cart/$itemId');
    final res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': prefs.getString('token')!,
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        cartItems.removeAt(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: _fetching
          ? Center(child: const CircularProgressIndicator())
          : cartItems.isEmpty
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
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              // Delete the item when swiped
                              deleteCartItem(index);

                              // Show a snackbar notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${item['name']} removed from cart.'),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  item['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
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
