// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'productdetails.dart'; // Import the ProductDetailsPage

class ProductPage extends StatefulWidget {
  final String categoryName; // Add categoryName to constructor

  // Modify the constructor to accept categoryName
  const ProductPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 0;

  static const List<String> _categories = <String>[
    'Spare Parts',
    'Battery',
    'Wheels',
    'Accessories',
    'Regular Maintenance',
  ];

  static const List<String> _categoryImages = <String>[
    'assets/images/part.jpg',
    'assets/images/battry.jpg',
    'assets/images/wheel.jpg',
    'assets/images/accs.jpg',
    'assets/images/oil.jpg',
  ];

  static const List<List<Map<String, dynamic>>> _products =
      <List<Map<String, dynamic>>>[
    [
      {
        'name': 'Engine Oil',
        'description': 'High-quality engine oil for all car engines.',
        'price': '20 USD',
        'image': 'assets/images/oil.jpg',
        'compatibility': ['All car types'],
      },
      {
        'name': 'Brake Pads',
        'description': 'Durable brake pads for various car models.',
        'price': '25 USD',
        'image': 'assets/images/brake_pads.jpg',
        'compatibility': ['Sedans', 'SUVs'],
      },
      {
        'name': 'Spark Plugs',
        'description':
            'Long-lasting spark plugs for enhanced engine performance.',
        'price': '15 USD',
        'image': 'assets/images/spark_plugs.jpg',
        'compatibility': ['Sedans', 'SUVs', 'Trucks'],
      },
    ],
    [
      {
        'name': 'Car Battery',
        'description': 'Powerful car battery for various vehicle models.',
        'price': '50 USD',
        'image': 'assets/images/car_battery.jpg',
        'compatibility': ['Sedans', 'SUVs'],
      },
      {
        'name': 'Truck Battery',
        'description': 'Heavy-duty truck battery for larger vehicles.',
        'price': '75 USD',
        'image': 'assets/images/truck_battery.jpg',
        'compatibility': ['Trucks', 'Heavy-duty vehicles'],
      },
    ],
    [
      {
        'name': 'Car Tires',
        'description': 'Durable car tires designed for road safety.',
        'price': '100 USD',
        'image': 'assets/images/car_tires.jpg',
        'compatibility': ['Sedans', 'SUVs', 'Hatchbacks'],
      },
      {
        'name': 'Truck Tires',
        'description': 'Heavy-duty tires built for trucks and larger vehicles.',
        'price': '120 USD',
        'image': 'assets/images/truck_tires.jpg',
        'compatibility': ['Trucks', 'Commercial vehicles'],
      },
    ],
    [
      {
        'name': 'Car Tools',
        'description': 'Essential car tools for basic vehicle repairs.',
        'price': '30 USD',
        'image': 'assets/images/car_tools.jpg',
        'compatibility': ['All car types'],
      },
      {
        'name': 'Jumper Cables',
        'description': 'High-quality jumper cables for emergency starts.',
        'price': '10 USD',
        'image': 'assets/images/jumper_cables.jpg',
        'compatibility': ['All car types'],
      },
    ],
    [
      {
        'name': 'Oil Change',
        'description': 'Complete oil change service for engine maintenance.',
        'price': '40 USD',
        'image': 'assets/images/oil_change.jpg',
        'compatibility': ['All car types'],
      },
      {
        'name': 'Tire Rotation',
        'description': 'Tire rotation service for improved tire life.',
        'price': '35 USD',
        'image': 'assets/images/tire_rotation.jpg',
        'compatibility': ['All car types'],
      },
    ],
  ];

  @override
  void initState() {
    super.initState();
    // Find the selected index for the category
    _selectedIndex = _categories.indexOf(widget.categoryName);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text(widget.categoryName), // Use the category name here
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categories.length, (index) {
                  return GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: _selectedIndex == index
                              ? const Color.fromARGB(255, 24, 17, 122)
                              : Colors.grey[300],
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(_categoryImages[index]),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? const Color.fromARGB(255, 25, 27, 158)
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
          const Divider(),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600
                    ? 3
                    : 2, // Responsive layout
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products[_selectedIndex].length,
              itemBuilder: (context, index) {
                var product = _products[_selectedIndex][index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to ProductDetailsPage and pass the product details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product, // Pass the selected product here
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            product['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product['description'],
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product['price'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 5, 40, 134),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            // Handle add to cart logic here
                          },
                          child: const Row(
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
