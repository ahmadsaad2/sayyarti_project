import 'package:flutter/material.dart';

class WorkshopPage extends StatefulWidget {
  final String workshopType; // Parameter to filter workshops by type

  const WorkshopPage({Key? key, required this.workshopType}) : super(key: key);

  @override
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
      'image': 'assets/images/workshop1.jpg',
      'rating': 4.5,
      'location': 'New York',
      'details': 'Expert in car repairs and maintenance.',
      'type': 'Mechanics',
    },
    {
      'name': 'Quick Fix Garage',
      'image': 'assets/images/workshop2.jpg',
      'rating': 4.0,
      'location': 'Los Angeles',
      'details': 'Fast and affordable service for all cars.',
      'type': 'Electrical',
    },
    {
      'name': 'Super Tires Workshop',
      'image': 'assets/images/workshop3.jpg',
      'rating': 4.7,
      'location': 'San Francisco',
      'details': 'Specializes in tire replacement and balancing.',
      'type': 'Denting',
    },
    {
      'name': 'Engine Masters',
      'image': 'assets/images/workshop4.jpg',
      'rating': 4.8,
      'location': 'Chicago',
      'details': 'Top-rated for engine diagnostics and repairs.',
      'type': 'Mechanics',
    },
    {
      'name': 'Elite Auto Experts',
      'image': 'assets/images/workshop5.jpg',
      'rating': 4.3,
      'location': 'Miami',
      'details': 'Comprehensive vehicle services for all brands.',
      'type': 'Electrical',
    },
  ];

  // Apply filters like city and rating
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
                  'New York',
                  'Los Angeles',
                  'San Francisco',
                  'Chicago',
                  'Miami'
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
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredWorkshops.length,
                    itemBuilder: (context, index) {
                      var workshop = filteredWorkshops[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                workshop['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 120,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                workshop['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Rating: ${workshop['rating']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                workshop['details'],
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
    );
  }
}
