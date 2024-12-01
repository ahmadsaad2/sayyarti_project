import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BasketPage extends StatefulWidget {
  @override
  _BasketPage createState() => _BasketPage();
}

class _BasketPage extends State<BasketPage> {
  // Tracks the currently selected category
  int _selectedIndex = 0;

  // Define categories and corresponding images
  static const List<String> _categories = <String>[
    'Spare Parts',
    'Battery',
    'Wheels',
    'Accessories',
    'Regular Maintenance',
  ];

  static const List<String> _categoryImages = <String>[
    'assets/images/part.jpg', // Path to your images
    'assets/images/battry.jpg',
    'assets/images/wheel.jpg',
    'assets/images/accs.jpg',
    'assets/images/oil.jpg',
  ];

  // Corresponding product lists for each category (Placeholder for now)
  static const List<List<Map<String, String>>> _products =
      <List<Map<String, String>>>[
    [
      // Spare Parts
      {
        'name': 'Engine Oil',
        'description': 'High-quality engine oil',
        'price': '20 USD',
        'image': 'assets/images/engine_oil.jpg'
      },
      {
        'name': 'Brake Pads',
        'description': 'Durable brake pads',
        'price': '25 USD',
        'image': 'assets/images/brake_pads.jpg'
      },
      {
        'name': 'Spark Plugs',
        'description': 'Long-lasting spark plugs',
        'price': '15 USD',
        'image': 'assets/images/spark_plugs.jpg'
      },
    ],
    [
      // Battery
      {
        'name': 'Car Battery',
        'description': 'Powerful car battery',
        'price': '50 USD',
        'image': 'assets/images/car_battery.jpg'
      },
      {
        'name': 'Truck Battery',
        'description': 'Heavy-duty truck battery',
        'price': '75 USD',
        'image': 'assets/images/truck_battery.jpg'
      },
    ],
    [
      // Wheels
      {
        'name': 'Car Tires',
        'description': 'Durable car tires',
        'price': '100 USD',
        'image': 'assets/images/car_tires.jpg'
      },
      {
        'name': 'Truck Tires',
        'description': 'Heavy-duty truck tires',
        'price': '120 USD',
        'image': 'assets/images/truck_tires.jpg'
      },
    ],
    [
      // Accessories
      {
        'name': 'Car Tools',
        'description': 'Essential car tools',
        'price': '30 USD',
        'image': 'assets/images/car_tools.jpg'
      },
      {
        'name': 'Jumper Cables',
        'description': 'High-quality jumper cables',
        'price': '10 USD',
        'image': 'assets/images/jumper_cables.jpg'
      },
    ],
    [
      // Regular Maintenance
      {
        'name': 'Oil Change',
        'description': 'Complete oil change service',
        'price': '40 USD',
        'image': 'assets/images/oil_change.jpg'
      },
      {
        'name': 'Tire Rotation',
        'description': 'Tire rotation service',
        'price': '35 USD',
        'image': 'assets/images/tire_rotation.jpg'
      },
    ],
  ];

  // Cart items
  List<String> cart = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(String productName) {
    setState(() {
      cart.add(productName);
      // Show a Snackbar when an item is added to the cart
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$productName added to cart'),
        duration: Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text(_categories[
            _selectedIndex]), // Display selected category at the top
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to Cart Page (not implemented here)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selection row with circular icons and headers (Scrollable)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _onItemTapped(index);
                    },
                    child: Column(
                      children: [
                        // Circle image with padding below
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: _selectedIndex == index
                              ? Colors.amber[800]
                              : Colors.grey[300],
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(_categoryImages[index]),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Category header text
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.amber[800]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Divider(),

          // Display products for the selected category
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products[_selectedIndex].length,
              itemBuilder: (context, index) {
                var product = _products[_selectedIndex][index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Product image
                      Expanded(
                        child: Image.asset(
                          product['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        ),
                      ),
                      // Product name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Product description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product['description']!,
                          style: TextStyle(color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Product price
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['price']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // 3D effect Add to Cart button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.amber[
                              800], // Replace 'primary' with 'backgroundColor'
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          _addToCart(product['name']!);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_shopping_cart),
                            SizedBox(width: 8),
                            Text('Add to Cart'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cogs),
            label: 'Spare Parts',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.carBattery),
            label: 'Battery',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wheelchair),
            label: 'Wheels',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.toolbox),
            label: 'Accessories',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.tools),
            label: 'Maintenance',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
