import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productdetails.dart';
import '../cart/CartPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final String categoryName;

  const ProductPage({super.key, required this.categoryName});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 0;
  final String _selectedType = "All";
  String _selectedCarCategory = "All";
  String _selectedPriceOrder = "Default";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final List<List<Map<String, dynamic>>> _products = [];
  var _isLoading = false;

  static const List<String> _categories = <String>[
    'Spare Parts',
    'Battery',
    'Wheels',
    'Accessories',
    'Maintenance',
  ];

  static const List<String> _categoryImages = <String>[
    'assets/images/part.jpg',
    'assets/images/battry.jpg',
    'assets/images/wheel.jpg',
    'assets/images/accs.jpg',
    'assets/images/oil.jpg',
  ];

  // static const List<List<Map<String, dynamic>>> _products =
  //     <List<Map<String, dynamic>>>[
  //   [
  //     {
  //       'name': 'Engine Oil',
  //       'description': 'High-quality engine oil for all car engines.',
  //       'price': 40,
  //       'image': 'assets/images/oil.jpg',
  //       'compatibility': ['All car types'],

  //     },
  //     {
  //       'name': 'Brake Pads',
  //       'description': 'Durable brake pads for various car models.',
  //       'price': 25,
  //       'image': 'assets/images/brake_pads.jpg',
  //       'compatibility': ['Sedans', 'SUVs'],

  //     },
  //   ],
  //   [
  //     {
  //       'name': 'Car Battery',
  //       'description': 'Powerful car battery for various vehicle models.',
  //       'price': 50,
  //       'image': 'assets/images/car_battery.jpg',
  //       'compatibility': ['Sedans', 'SUVs'],
  //     },
  //   ],
  //   [
  //     {
  //       'name': 'Car Tires',
  //       'description': 'Durable car tires designed for road safety.',
  //       'price': 100,
  //       'image': 'assets/images/car_tires.jpg',
  //       'compatibility': ['Sedans', 'SUVs', 'Hatchbacks'],
  //     },
  //   ],
  //   [
  //     {
  //       'name': 'Car Tools',
  //       'description': 'Essential car tools for basic vehicle repairs.',
  //       'price': 30,
  //       'image': 'assets/images/car_tools.jpg',
  //       'compatibility': ['All car types'],
  //     },
  //   ],
  //   [
  //     {
  //       'name': 'Oil Change',
  //       'description': 'Complete oil change service for engine maintenance.',
  //       'price': 40,
  //       'image': 'assets/images/oil_change.jpg',
  //       'compatibility': ['All car types'],
  //     },
  //   ],
  // ];

  List<Map<String, dynamic>> _filteredProducts = [];

  void _getProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.http(backendUrl, '/user/products');
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': prefs.getString('token')!,
        },
      );
      var jsonResponse = json.decode(res.body);
      print('response$jsonResponse');
      final Map<String, List<Map<String, dynamic>>> groupedProducts = {};
      for (var product in jsonResponse['products']) {
        final category = product['category'];
        if (!groupedProducts.containsKey(category)) {
          groupedProducts[category] = [];
        }
        groupedProducts[category]!.add({
          'name': product['part_name'],
          'description': product['description'] ?? '',
          'price': double.parse(product['price']), // Convert price to double
          'image': product['image_url'],
          'compatibility':
              product['compatible_cars'] ?? [], // Handle null compatibility
        });
      }
      setState(() {
        _products.clear();
        for (var category in _categories) {
          if (groupedProducts.containsKey(category)) {
            _products.add(groupedProducts[category]!);
          } else {
            _products.add([]);
          }
        }
        _selectedIndex = _categories.indexOf(widget.categoryName);
        _filteredProducts = List.from(_products[_selectedIndex]);
      });
    } on Exception catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
    // _selectedIndex = _categories.indexOf(widget.categoryName);
    // _filteredProducts = List.from(_products[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _products[_selectedIndex].where((product) {
        final matchesType =
            _selectedType == "All" || product['name'].contains(_selectedType);
        final matchesCarCategory = _selectedCarCategory == "All" ||
            product['compatibility'].contains(_selectedCarCategory);
        final matchesSearch = _searchQuery.isEmpty ||
            product['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['description']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        return matchesType && matchesCarCategory && matchesSearch;
      }).toList();

      if (_selectedPriceOrder == "High to Low") {
        _filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (_selectedPriceOrder == "Low to High") {
        _filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedCarCategory,
                items: ["All", "Sedans", "SUVs", "Trucks"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCarCategory = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedPriceOrder,
                items: ["Default", "High to Low", "Low to High"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriceOrder = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text("Apply Filters"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: const CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(widget.categoryName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  onPressed: _showFilterBottomSheet,
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _applyFilters();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = "";
                              _applyFilters();
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_categories.length, (index) {
                        return GestureDetector(
                          onTap: () => _onItemTapped(index),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: _selectedIndex == index
                                      ? const Color.fromARGB(255, 24, 17, 122)
                                      : Colors.grey[300],
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundImage:
                                        AssetImage(_categoryImages[index]),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    _categories[index],
                                    style: TextStyle(
                                      color: _selectedIndex == index
                                          ? const Color.fromARGB(
                                              255, 25, 27, 158)
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      var product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: {
                                  ...product,
                                  'price': product['price'].toString()
                                }, // Ensure price is passed as a String
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    product['image'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                  // Image.asset(
                                  //   product['image'],
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "${product['price']} SR",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 36, 128, 151),
                                    fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 19, 21, 163),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        product: {
                                          ...product,
                                          'price': product['price'].toString()
                                        }, // Ensure price is passed as a String
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 245, 242, 242)),
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
