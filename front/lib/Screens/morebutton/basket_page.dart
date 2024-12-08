// basket_page.dart
import 'package:flutter/material.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basket Page")),
      body: const Center(child: Text("This is the Basket page!")),
    );
  }
}
