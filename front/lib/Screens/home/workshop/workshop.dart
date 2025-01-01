import 'package:flutter/material.dart';
import 'workshopdetails.dart';

class WorkshopPage extends StatefulWidget {
  final String workshopType; // Parameter to filter workshops by type

  const WorkshopPage({Key? key, required this.workshopType}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkshopPageState createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  String _selectedSort = 'Rating';
  double _selectedRating = 0;
  String _selectedCity = 'All';
  String _searchQuery = '';

  // Define workshops for different types
  final List<Map<String, dynamic>> _allWorkshops = [
    {
      'name': 'Auto Care Center',
      'image': 'assets/images/sdd.jpg',
      'rating': 4.5,
      'location': 'Nablus',
      'details': 'Expert in car repairs and maintenance.',
      'type': 'Mechanics',
      'contact': '123-456-789',
      'services': ['Oil Change', 'Brake Repair', 'General Maintenance'],
      'carBrands': ['Toyota', 'Hyundai', 'BMW'],
    },
    {
      'name': 'Quick Fix Garage',
      'image': 'assets/images/fss.jpg',
      'rating': 4.0,
      'location': 'Nablus',
      'details': 'Fast and affordable service for all cars.',
      'type': 'Electrical',
      'contact': '987-654-321',
      'services': ['Electrical Repair', 'Battery Replacement'],
      'carBrands': ['Ford', 'Chevrolet', 'Nissan'],
    },
    {
      'name': 'Super Tires Workshop',
      'image': 'assets/images/sdd.jpg',
      'rating': 4.7,
      'location': 'Nablus',
      'details': 'Specializes in tire replacement and balancing.',
      'type': 'Denting',
      'contact': '456-789-123',
      'services': ['Tire Replacement', 'Wheel Balancing'],
      'carBrands': ['Toyota', 'Honda', 'Mercedes'],
    },
    {
      'name': 'Engine Masters',
      'image': 'assets/images/sdd.jpg',
      'rating': 4.8,
      'location': 'Nablus',
      'details': 'Top-rated for engine diagnostics and repairs.',
      'type': 'Mechanics',
      'contact': '321-654-987',
      'services': ['Engine Diagnostics', 'Engine Repair'],
      'carBrands': ['BMW', 'Audi', 'Volkswagen'],
    },
    {
      'name': 'Elite Auto Experts',
      'image': 'assets/images/fss.jpg',
      'rating': 4.3,
      'location': 'Nablus',
      'details': 'Comprehensive vehicle services for all brands.',
      'type': 'Electrical',
      'contact': '789-123-456',
      'services': ['Electrical Repair', 'Lighting Installation'],
      'carBrands': ['Hyundai', 'Kia', 'Mazda'],
    },
  ];

  void _applyFilters() async {
    final Map<String, dynamic>? filters =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apply Filters'),
          content: Column(
            children: [
              DropdownButton<String>(
                value: _selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue!;
                  });
                },
                items: [
                  'All',
                  'Nablus',
                  'Ramallah',
                  'Hebron',
                  'Jenin',
                  'Toubas'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Slider(
                value: _selectedRating,
                min: 0,
                max: 5,
                divisions: 5,
                label: _selectedRating.toString(),
                onChanged: (double value) {
                  setState(() {
                    _selectedRating = value;
                  });
                },
              ),
              const Text('Rating Filter'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.pop(context,
                    {'city': _selectedCity, 'rating': _selectedRating});
              },
            ),
          ],
        );
      },
    );

    if (filters != null) {
      setState(() {
        _selectedCity = filters['city'];
        _selectedRating = filters['rating'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter workshops based on selected criteria
    var filteredWorkshops = _allWorkshops.where((workshop) {
      bool matchesType = workshop['type'] == widget.workshopType;
      bool matchesCity =
          workshop['location'] == _selectedCity || _selectedCity == 'All';
      bool matchesRating = workshop['rating'] >= _selectedRating;
      bool matchesSearch =
          workshop['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesCity && matchesRating && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workshopType} Workshops'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Workshops',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          const Divider(),

          // Sort and Filter buttons under the search bar, horizontally aligned
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Sort button with text next to icon
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sort By'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('Rating'),
                                    leading: Radio<String>(
                                      value: 'Rating',
                                      groupValue: _selectedSort,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSort = value!;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Location'),
                                    leading: Radio<String>(
                                      value: 'Location',
                                      groupValue: _selectedSort,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSort = value!;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const Text(
                      'Sort',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                // Filter button with text next to icon
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _applyFilters,
                    ),
                    const Text(
                      'Filter',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredWorkshops.isEmpty
                ? const Center(child: Text('No workshops available'))
                : ListView.builder(
                    itemCount: filteredWorkshops.length,
                    itemBuilder: (context, index) {
                      var workshop = filteredWorkshops[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the workshop details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkshopDetailsPage(
                                workshop: workshop,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              // Image on the left side
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  workshop['image'],
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Details on the right side
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title with bold text
                                      Text(
                                        workshop['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      // Rating
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${workshop['rating']}',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      // Location
                                      Text(
                                        'Location: ${workshop['location']}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 6),
                                      // Short description
                                      Text(
                                        workshop['details'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
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
