// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../clientbooking/bookingpage.dart';

// class WorkshopDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> workshop;

//   const WorkshopDetailsPage({super.key, required this.workshop});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(workshop['name'] ?? 'Workshop Name'),
//         backgroundColor: const Color.fromARGB(255, 16, 80, 177),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               Clipboard.setData(ClipboardData(
//                   text: workshop['contact'] ?? 'No contact available'));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Contact copied to clipboard!')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Workshop Image
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16.0),
//                 child: Image.asset(
//                   workshop['image'] ??
//                       'assets/images/default.jpg', // Default fallback image
//                   fit: BoxFit.cover,
//                   height: 200,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Workshop Name and Rating
//             Text(
//               workshop['name'] ?? 'Default Name', // Null-safe fallback
//               style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: List.generate(
//                     5,
//                     (index) => Icon(
//                       index < workshop['rating']?.round()
//                           ? Icons.star
//                           : Icons.star_border,
//                       color: Colors.amber,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '(${workshop['rating'] ?? 0} Reviews)',
//                   style: const TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Location
//             Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.blue),
//                 const SizedBox(width: 8),
//                 Text(
//                   workshop['location'] ?? 'Unknown Location',
//                   style: const TextStyle(fontSize: 16, color: Colors.black87),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Contact Information
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Contact Information',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade900,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.blue.shade700),
//               ),
//               child: Text(
//                 workshop['contact'] ?? 'N/A',
//                 style: const TextStyle(fontSize: 16, color: Colors.black87),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // My Services Section
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Services Offered',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade900,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(
//                 (workshop['services'] as List<String>).length,
//                 (index) => Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.shade700),
//                   ),
//                   child: Text(
//                     workshop['services'][index],
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Car Brands Section
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Car Brands',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade900,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: List.generate(
//                 (workshop['carBrands'] as List<String>).length,
//                 (index) => Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.shade700),
//                   ),
//                   child: Text(
//                     workshop['carBrands'][index],
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 32),

//             // Buttons for Booking and Messaging
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BookingPage(workshop: workshop),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 7, 10, 163),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text(
//                       'Book Now',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8), // Spacing between buttons

//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Message sent to ${workshop['name']}'),
//                         duration: const Duration(seconds: 2),
//                       ));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 7, 10, 163),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text(
//                       'Send Message',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../clientbooking/bookingpage.dart';

class WorkshopDetailsPage extends StatefulWidget {
  final Map<String, dynamic> workshop;
  final int userId;

  const WorkshopDetailsPage({
    super.key,
    required this.workshop,
    required this.userId,
  });

  @override
  _WorkshopDetailsPageState createState() => _WorkshopDetailsPageState();
}

class _WorkshopDetailsPageState extends State<WorkshopDetailsPage> {
  List<String> _services = [];
  bool _isLoadingServices = true;
  LatLng? workshopLocation;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;
  double _averageRating = 0;

  @override
  void initState() {
    super.initState();

    _fetchServices();
    _initializeLocation();
    _fetchReviews(); // Fetch reviews when the page loads
  }

  void _initializeLocation() {
    final double? latitude = widget.workshop['latitude'];
    final double? longitude = widget.workshop['longitude'];
    print('Latitude: $latitude, Longitude: $longitude'); // Debugging
    if (latitude != null && longitude != null) {
      setState(() {
        workshopLocation = LatLng(latitude, longitude);
      });
    } else {
      print('Invalid or missing latitude/longitude'); // Debugging
    }
  }

  Future<void> _fetchServices() async {
    try {
      final url =
          Uri.http(backendUrl, '/api/services/all/${widget.workshop['id']}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // final ur
      // final response = await http.get(
      //   Uri.parse(
      //       '$backendUrl/api/services?company_id=${widget.workshop['id']}'),
      // );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _services = List<String>.from(data.map((service) => service['name']));
          _isLoadingServices = false;
        });
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      setState(() {
        _isLoadingServices = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load services: $e')),
      );
    }
  }

  Future<void> _fetchReviews() async {
    try {
      final url = Uri.http(backendUrl, '/api/reviews/${widget.workshop['id']}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // final response = await http.get(
      //   Uri.parse(
      //       '$backendUrl/api/reviews?company_id=${widget.workshop['id']}'),
      // );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _reviews = data;
          _isLoadingReviews = false;
          _calculateAverageRating(); // Calculate average rating after fetching reviews
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      setState(() {
        _isLoadingReviews = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reviews: $e')),
      );
    }
  }

  void _calculateAverageRating() {
    if (_reviews.isEmpty) {
      setState(() {
        _averageRating = 0;
      });
      return;
    }

    double totalRating = 0;
    for (final review in _reviews) {
      totalRating += review['rating'];
    }
    setState(() {
      _averageRating = totalRating / _reviews.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workshop['name'] ?? 'Workshop Name'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
        actions: [
          IconButton(
            icon: const Icon(Icons.thumb_up), // Like button
            onPressed: () {
              // Navigate to the Rating Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingPage(
                    workshopId: widget.workshop['id'], // Pass workshop ID
                    userId: (widget.userId),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                  text: widget.workshop['contact'] ?? 'No contact available'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Workshop Image
            Center(
              child: Image.network(
                widget.workshop['image'] ??
                    'https://via.placeholder.com/200', // Fallback image URL
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null)
                    return child; // Image is fully loaded
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons
                      .error); // Display an error icon if the image fails to load
                },
              ),
            ),
            const SizedBox(height: 16),

            // Workshop Name and Rating
            Text(
              widget.workshop['name'] ?? 'Default Name', // Null-safe fallback
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < _averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_averageRating.toStringAsFixed(1)} Reviews)',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  widget.workshop['location'] ?? 'Unknown Location',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Map Section
            if (workshopLocation != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: workshopLocation!,
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: workshopLocation!,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Text('Location data is unavailable.'),
              ),

            const SizedBox(height: 16),

            // Contact Information
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade700),
              ),
              child: Text(
                widget.workshop['contact'] ?? 'N/A',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),

            // My Services Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Services Offered',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLoadingServices
                ? const CircularProgressIndicator()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _services.length,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade700),
                        ),
                        child: Text(
                          _services[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 16),

            // Car Brands Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Car Brands',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                (widget.workshop['carBrands'] as List<String>).length,
                (index) => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade700),
                  ),
                  child: Text(
                    widget.workshop['carBrands'][index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Reviews Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLoadingReviews
                ? const CircularProgressIndicator()
                : _reviews.isEmpty
                    ? const Text('No reviews yet.')
                    : Column(
                        children: [
                          Text(
                            'Average Rating: ${_averageRating.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _reviews.length,
                            itemBuilder: (context, index) {
                              final review = _reviews[index];
                              return ListTile(
                                leading: const Icon(Icons.person, size: 40),
                                title: Text('Anonymous'),
                                subtitle: Text(review['comment'] ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      starIndex < review['rating']
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

            const SizedBox(height: 32),

            // Buttons for Booking and Messaging
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            workshop: widget.workshop,
                            userid: widget.userId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 10, 163),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between buttons

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Message sent to ${widget.workshop['name']}'),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 10, 163),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Send Message',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingPage extends StatefulWidget {
  final int workshopId;
  final int userId;

  const RatingPage({super.key, required this.workshopId, required this.userId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.http(backendUrl, '/api/reviews');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'company_id': widget.workshopId,
          'user_id': widget.userId,
          'rating': _rating,
          'comment': _commentController.text,
        }),
      );

      // final response = await http.post(
      //   Uri.parse('$backendUrl/api/reviews'),
      //   headers: {'Content-Type': 'application/json'},
      // body: json.encode({
      //   'company_id': widget.workshopId,
      //   'user_id': widget.userId,
      //   'rating': _rating,
      //   'comment': _commentController.text,
      // }),
      // );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
        Navigator.pop(context); // Go back to the previous page
      } else {
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Workshop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate this Workshop:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < _rating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add a Comment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your review here...',
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Submit Review'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
