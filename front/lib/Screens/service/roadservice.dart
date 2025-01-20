import 'package:flutter/material.dart';

// Individual Service Detail Page
class RoadServiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> roadService;

  const RoadServiceDetailsPage({super.key, required this.roadService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roadService['serviceName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Name and Description
            Text(
              roadService['serviceName'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              roadService['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // List of People Offering the Service
            const Text(
              'People Offering This Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: roadService['people'].length,
              itemBuilder: (context, index) {
                var person = roadService['people'][index];
                return ListTile(
                  title: Text(person['name']),
                  subtitle: Text(person['contact']),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(person['image']),
                  ),
                  onTap: () {
                    // Navigate to person details page or call
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(person['name']),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contact: ${person['contact']}'),
                              Text('Location: ${person['location']}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoadServicePage extends StatefulWidget {
  final String roadServiceType; // Parameter to filter road services by type

  const RoadServicePage({super.key, required this.roadServiceType});

  @override
  // ignore: library_private_types_in_public_api
  _RoadServicePageState createState() => _RoadServicePageState();
}

class _RoadServicePageState extends State<RoadServicePage> {
  String _selectedSort = 'Rating';
  double _selectedRating = 0;
  String _selectedCity = 'All';
  String _searchQuery = '';

  // Define road services for different types
  final List<Map<String, dynamic>> _allRoadServices = [
    {
      'serviceName': 'Jump Start',
      'image': 'assets/images/5.jpg',
      'rating': 4.5,
      'location': 'Nablus',
      'description': 'Quick and efficient jump-start service.',
      'type': 'Jump Start', // Changed type to match service name
      'people': [
        {
          'name': 'John Doe',
          'contact': '123-456-789',
          'location': 'Nablus',
          'image': 'assets/images/5.jpg',
        },
        {
          'name': 'Jane Smith',
          'contact': '987-654-321',
          'location': 'Ramallah',
          'image': 'assets/images/5.jpg',
        }
      ],
    },
    {
      'serviceName': 'Tire Problems',
      'image': 'assets/images/5.jpg',
      'rating': 4.2,
      'location': 'Ramallah',
      'description': 'Reliable tire change and repair services.',
      'type': 'Tire Problems',
      'people': [
        {
          'name': 'Mark Johnson',
          'contact': '321-654-987',
          'location': 'Ramallah',
          'image': 'assets/images/5.jpg',
        },
        {
          'name': 'Lucy Brown',
          'contact': '654-321-987',
          'location': 'Jenin',
          'image': 'assets/images/5.jpg',
        }
      ],
    },
    {
      'serviceName': 'Towing Service',
      'image': 'assets/images/5.jpg',
      'rating': 4.7,
      'location': 'Nablus',
      'description': 'Fast and affordable towing services for all vehicles.',
      'type': 'Towing Service',
      'people': [
        {
          'name': 'Steve Williams',
          'contact': '555-123-456',
          'location': 'Nablus',
          'image': 'assets/images/5.jpg',
        },
        {
          'name': 'Ella Martin',
          'contact': '555-987-654',
          'location': 'Hebron',
          'image': 'assets/images/5.jpg',
        }
      ],
    },
    {
      'serviceName': 'Fuel Delivery',
      'image': 'assets/images/5.jpg',
      'rating': 4.3,
      'location': 'Hebron',
      'description': 'Emergency fuel delivery service for stranded vehicles.',
      'type': 'Fuel Delivery',
      'people': [
        {
          'name': 'Alice Walker',
          'contact': '777-123-987',
          'location': 'Hebron',
          'image': 'assets/images/5.jpg',
        },
        {
          'name': 'David Scott',
          'contact': '777-987-654',
          'location': 'Jenin',
          'image': 'assets/images/5.jpg',
        }
      ],
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
    // Filter road services based on selected criteria
    var filteredRoadServices = _allRoadServices.where((service) {
      bool matchesType = service['type'] == widget.roadServiceType;
      bool matchesCity =
          service['location'] == _selectedCity || _selectedCity == 'All';
      bool matchesRating = service['rating'] >= _selectedRating;
      bool matchesSearch = service['serviceName']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesType && matchesCity && matchesRating && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.roadServiceType} Services'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Services',
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
            child: filteredRoadServices.isEmpty
                ? const Center(child: Text('No services available'))
                : ListView.builder(
                    itemCount: filteredRoadServices.length,
                    itemBuilder: (context, index) {
                      var service = filteredRoadServices[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the service details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoadServiceDetailsPage(
                                roadService: service,
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  service['image'],
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service['serviceName'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 18,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${service['rating']}',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Location: ${service['location']}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        service['description'],
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
