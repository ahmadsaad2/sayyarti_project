// import 'package:flutter/material.dart';
// import 'workshopdetails.dart';

// class WorkshopPage extends StatefulWidget {
//   final String workshopType; // Parameter to filter workshops by type

//   const WorkshopPage({super.key, required this.workshopType});

//   @override
//   // ignore: library_private_types_in_public_api
//   _WorkshopPageState createState() => _WorkshopPageState();
// }

// class _WorkshopPageState extends State<WorkshopPage> {
//   String _selectedSort = 'Rating';
//   double _selectedRating = 0;
//   String _selectedCity = 'All';
//   String _searchQuery = '';

//   // Define workshops for different types
//   final List<Map<String, dynamic>> _allWorkshops = [
//     {
//       'name': 'Auto Care Center',
//       'image': 'assets/images/sdd.jpg',
//       'rating': 4.5,
//       'location': 'Nablus',
//       'details': 'Expert in car repairs and maintenance.',
//       'type': 'Mechanics',
//       'contact': '123-456-789',
//       'services': ['Oil Change', 'Brake Repair', 'General Maintenance'],
//       'carBrands': ['Toyota', 'Hyundai', 'BMW'],
//     },
//     {
//       'name': 'Quick Fix Garage',
//       'image': 'assets/images/fss.jpg',
//       'rating': 4.0,
//       'location': 'Nablus',
//       'details': 'Fast and affordable service for all cars.',
//       'type': 'Electrical',
//       'contact': '987-654-321',
//       'services': ['Electrical Repair', 'Battery Replacement'],
//       'carBrands': ['Ford', 'Chevrolet', 'Nissan'],
//     },
//     {
//       'name': 'Super Tires Workshop',
//       'image': 'assets/images/sdd.jpg',
//       'rating': 4.7,
//       'location': 'Nablus',
//       'details': 'Specializes in tire replacement and balancing.',
//       'type': 'Denting',
//       'contact': '456-789-123',
//       'services': ['Tire Replacement', 'Wheel Balancing'],
//       'carBrands': ['Toyota', 'Honda', 'Mercedes'],
//     },
//     {
//       'name': 'Engine Masters',
//       'image': 'assets/images/sdd.jpg',
//       'rating': 4.8,
//       'location': 'Nablus',
//       'details': 'Top-rated for engine diagnostics and repairs.',
//       'type': 'Mechanics',
//       'contact': '321-654-987',
//       'services': ['Engine Diagnostics', 'Engine Repair'],
//       'carBrands': ['BMW', 'Audi', 'Volkswagen'],
//     },
//     {
//       'name': 'Elite Auto Experts',
//       'image': 'assets/images/fss.jpg',
//       'rating': 4.3,
//       'location': 'Nablus',
//       'details': 'Comprehensive vehicle services for all brands.',
//       'type': 'Electrical',
//       'contact': '789-123-456',
//       'services': ['Electrical Repair', 'Lighting Installation'],
//       'carBrands': ['Hyundai', 'Kia', 'Mazda'],
//     },
//   ];

//   void _applyFilters() async {
//     final Map<String, dynamic>? filters =
//         await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Apply Filters'),
//           content: Column(
//             children: [
//               DropdownButton<String>(
//                 value: _selectedCity,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCity = newValue!;
//                   });
//                 },
//                 items: [
//                   'All',
//                   'Nablus',
//                   'Ramallah',
//                   'Hebron',
//                   'Jenin',
//                   'Toubas'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               Slider(
//                 value: _selectedRating,
//                 min: 0,
//                 max: 5,
//                 divisions: 5,
//                 label: _selectedRating.toString(),
//                 onChanged: (double value) {
//                   setState(() {
//                     _selectedRating = value;
//                   });
//                 },
//               ),
//               const Text('Rating Filter'),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Apply'),
//               onPressed: () {
//                 Navigator.pop(context,
//                     {'city': _selectedCity, 'rating': _selectedRating});
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (filters != null) {
//       setState(() {
//         _selectedCity = filters['city'];
//         _selectedRating = filters['rating'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Filter workshops based on selected criteria
//     var filteredWorkshops = _allWorkshops.where((workshop) {
//       bool matchesType = workshop['type'] == widget.workshopType;
//       bool matchesCity =
//           workshop['location'] == _selectedCity || _selectedCity == 'All';
//       bool matchesRating = workshop['rating'] >= _selectedRating;
//       bool matchesSearch =
//           workshop['name'].toLowerCase().contains(_searchQuery.toLowerCase());
//       return matchesType && matchesCity && matchesRating && matchesSearch;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.workshopType} Workshops'),
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Search Workshops',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (query) {
//                 setState(() {
//                   _searchQuery = query;
//                 });
//               },
//             ),
//           ),
//           const Divider(),

//           // Sort and Filter buttons under the search bar, horizontally aligned
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // Sort button with text next to icon
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.sort),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Sort By'),
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ListTile(
//                                     title: const Text('Rating'),
//                                     leading: Radio<String>(
//                                       value: 'Rating',
//                                       groupValue: _selectedSort,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _selectedSort = value!;
//                                         });
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                   ),
//                                   ListTile(
//                                     title: const Text('Location'),
//                                     leading: Radio<String>(
//                                       value: 'Location',
//                                       groupValue: _selectedSort,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _selectedSort = value!;
//                                         });
//                                         Navigator.pop(context);
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     const Text(
//                       'Sort',
//                       style: TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 // Filter button with text next to icon
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.filter_list),
//                       onPressed: _applyFilters,
//                     ),
//                     const Text(
//                       'Filter',
//                       style: TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: filteredWorkshops.isEmpty
//                 ? const Center(child: Text('No workshops available'))
//                 : ListView.builder(
//                     itemCount: filteredWorkshops.length,
//                     itemBuilder: (context, index) {
//                       var workshop = filteredWorkshops[index];
//                       return GestureDetector(
//                         onTap: () {
//                           // Navigate to the workshop details page
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => WorkshopDetailsPage(
//                                 workshop: workshop,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           elevation: 5,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Row(
//                             children: [
//                               // Image on the left side
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.asset(
//                                   workshop['image'],
//                                   fit: BoxFit.cover,
//                                   width: 120,
//                                   height: 120,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               // Details on the right side
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // Title with bold text
//                                       Text(
//                                         workshop['name'],
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 6),
//                                       // Rating
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.star,
//                                             size: 18,
//                                             color: Colors.amber,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             '${workshop['rating']}',
//                                             style: const TextStyle(
//                                                 color: Colors.grey),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 6),
//                                       // Location
//                                       Text(
//                                         'Location: ${workshop['location']}',
//                                         style:
//                                             const TextStyle(color: Colors.grey),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       // Short description
//                                       Text(
//                                         workshop['details'],
//                                         style: const TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.black54,
//                                         ),
//                                         maxLines: 3,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../workshop/workshopdetails.dart';

class CompanyProfile {
  final int? id;
  final String? name;
  final String? address;
  final String? contact;
  final String? email;
  final String? website;
  final String? image;
  final int? userId;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final String? type;
  final List<String>? carBrands;

  CompanyProfile({
    this.id,
    this.name,
    this.address,
    this.contact,
    this.email,
    this.website,
    this.image,
    this.userId,
    this.latitude,
    this.longitude,
    this.rating,
    this.type,
    this.carBrands,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      image: json['image'] as String?,
      userId: json['user_id'] as int?,
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : null,
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : null,
      type: json['type'] as String?,
      carBrands: json['carBrands'] != null
          ? List<String>.from(json['carBrands'])
          : null,
    );
  }
}

class WorkshopPage extends StatefulWidget {
  final String workshopType; // Parameter to filter workshops by type

  const WorkshopPage({super.key, required this.workshopType});

  @override
  _WorkshopPageState createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  String _selectedSort = 'Rating';
  double _selectedRating = 0;
  String _selectedCity = 'All';
  String _searchQuery = '';
  List<CompanyProfile> _allWorkshops = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWorkshops();
  }

  Future<void> _fetchWorkshops() async {
    try {
      final url =
          Uri.http(backendUrl, '/api/company/type/${widget.workshopType}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debugging: Print the API response
        if (data['companies'] != null) {
          final List<dynamic> companiesJson = data['companies'];
          setState(() {
            _allWorkshops = companiesJson
                .map((json) => CompanyProfile.fromJson(json))
                .toList();
            _isLoading = false;
          });
        } else {
          throw Exception('No companies found');
        }
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load workshops: $e';
      });
    }
  }

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
      bool matchesCity = _selectedCity == 'All' ||
          workshop.address
                  ?.toLowerCase()
                  .contains(_selectedCity.toLowerCase()) ==
              true;
      bool matchesRating =
          _selectedRating == 0 || (workshop.rating ?? 0) >= _selectedRating;
      bool matchesSearch = _searchQuery.isEmpty ||
          workshop.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
              true;

      print('Workshop: ${workshop.name}');
      print('Matches City: $matchesCity');
      print('Matches Rating: $matchesRating');
      print('Matches Search: $matchesSearch');

      return matchesCity && matchesRating && matchesSearch;
    }).toList();

    print(
        'Filtered Workshops: $filteredWorkshops'); // Debugging: Print filtered workshops

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : filteredWorkshops.isEmpty
                        ? const Center(child: Text('No workshops available'))
                        : ListView.builder(
                            itemCount: filteredWorkshops.length,
                            itemBuilder: (context, index) {
                              var workshop = filteredWorkshops[index];
                              print(
                                  'Rendering Workshop: ${workshop.name}'); // Debugging: Print workshop name

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkshopDetailsPage(
                                        workshop: {
                                          'id': workshop.id,
                                          'name': workshop.name ??
                                              'Unknown Workshop',
                                          'location': workshop.address ??
                                              'Unknown Location',
                                          'contact': workshop.contact ?? 'N/A',
                                          'rating': workshop.rating ??
                                              0, // Default to 0 if null
                                          'image': workshop.image ??
                                              'assets/images/workshop.png',
                                          'carBrands': workshop.carBrands ?? [],
                                          'latitude': workshop.latitude ?? 0,
                                          'longitude': workshop.longitude ?? 0,
                                        },
                                        userId: workshop.userId ?? 0,
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
                                          'assets/images/workshop.png',
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
                                                workshop.name ?? 'No Name',
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
                                                    '${workshop.rating ?? 0}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              // Location
                                              Text(
                                                'Location: ${workshop.address ?? 'Unknown'}',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 6),
                                              // Short description
                                              Text(
                                                workshop.type ??
                                                    'No Description',
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
