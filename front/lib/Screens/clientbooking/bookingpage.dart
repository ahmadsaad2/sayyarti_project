// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'BookingSuccessPage.dart';

// class BookingPage extends StatefulWidget {
//   final Map<String, dynamic> workshop;

//   const BookingPage({super.key, required this.workshop});

//   @override
//   _BookingPageState createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? customerName;
//   String? phoneNumber;
//   String? selectedService;
//   String? problemDetails;
//   DateTime? preferredDate;
//   String? preferredTime;
//   String? method;
//   String? bookingStatus = "Pending";

//   File? problemImageOrVideo;
//   File? carLicense;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImageOrVideo() async {
//     final XFile? file = await _picker.pickImage(source: ImageSource.gallery) ??
//         await _picker.pickVideo(source: ImageSource.gallery);

//     if (file != null) {
//       setState(() {
//         problemImageOrVideo = File(file.path);
//       });
//     }
//   }

//   Future<void> _pickLicense() async {
//     final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

//     if (file != null) {
//       setState(() {
//         carLicense = File(file.path);
//       });
//     }
//   }

//   void _pickPreferredTime(BuildContext context) async {
//     final List<String> timeSlots = [
//       '8-9',
//       '9-10',
//       '10-11',
//       '11-12',
//       '12-1',
//       '1-2',
//       '2-3',
//       '3-4',
//       '4-5'
//     ];

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: timeSlots.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(timeSlots[index]),
//               onTap: () {
//                 setState(() {
//                   preferredTime = timeSlots[index];
//                 });
//                 Navigator.pop(context);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   void _logBookingDetails() {
//     print("Booking Details:");
//     print("Name: $customerName");
//     print("Mobile Number: $phoneNumber");
//     print("Service Required: $selectedService");
//     print("Problem Details: $problemDetails");
//     print(
//         "Preferred Date: ${preferredDate?.toLocal().toString().split(' ')[0]}");
//     print("Preferred Time: $preferredTime");
//     print("Method: $method");
//     print("Booking Status: $bookingStatus");
//     print(
//         "Problem Image/Video: ${problemImageOrVideo?.path ?? 'Not attached'}");
//     print("Car License: ${carLicense?.path ?? 'Not attached'}");
//   }

//   void _submitBooking() {
//     if (_formKey.currentState!.validate()) {
//       if (carLicense == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please attach your car license.')),
//         );
//         return;
//       }

//       // Check for null values
//       if (customerName == null ||
//           selectedService == null ||
//           preferredDate == null ||
//           preferredTime == null ||
//           method == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please complete all fields.')),
//         );
//         return;
//       }

//       // Save form data
//       _formKey.currentState!.save();

//       // Create a Map to store booking details
//       final bookingData = {
//         'customerName': customerName,
//         'phoneNumber': phoneNumber,
//         'selectedService': selectedService,
//         'problemDetails': problemDetails,
//         'preferredDate': preferredDate,
//         'preferredTime': preferredTime,
//         'method': method,
//       };

//       // Navigate to Success Page and pass the booking data
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => BookingSuccessPage(
//             bookingData: bookingData,
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book a Service'),
//         backgroundColor: const Color.fromARGB(255, 16, 80, 177),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 onSaved: (value) => customerName = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Mobile Number'),
//                 keyboardType: TextInputType.phone,
//                 onSaved: (value) => phoneNumber = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your mobile number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration:
//                     const InputDecoration(labelText: 'Service Required'),
//                 items: (widget.workshop['services'] as List<String>)
//                     .map((service) {
//                   return DropdownMenuItem(
//                     value: service,
//                     child: Text(service),
//                   );
//                 }).toList(),
//                 onChanged: (value) => selectedService = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select a service';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Problem Details'),
//                 maxLines: 4,
//                 onSaved: (value) => problemDetails = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please provide details about the problem.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _pickImageOrVideo,
//                 child: Text(problemImageOrVideo == null
//                     ? 'Attach Problem Image/Video'
//                     : 'File Attached'),
//               ),
//               if (problemImageOrVideo != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Attached File: ${problemImageOrVideo!.path.split('/').last}',
//                   style: const TextStyle(color: Colors.green),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _pickLicense,
//                 child: Text(carLicense == null
//                     ? 'Attach Car License'
//                     : 'License Attached'),
//               ),
//               if (carLicense != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'License File: ${carLicense!.path.split('/').last}',
//                   style: const TextStyle(color: Colors.green),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () => _pickPreferredTime(context),
//                 child: Text(preferredTime == null
//                     ? 'Select Preferred Time'
//                     : 'Selected Time: $preferredTime'),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   final pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(const Duration(days: 365)),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       preferredDate = pickedDate;
//                     });
//                   }
//                 },
//                 child: Text(preferredDate == null
//                     ? 'Pick Preferred Date'
//                     : 'Selected Date: ${preferredDate!.toLocal()}'
//                         .split(' ')[0]),
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Method'),
//                 items: ['Pickup', 'Drop-off'].map((method) {
//                   return DropdownMenuItem(
//                     value: method,
//                     child: Text(method),
//                   );
//                 }).toList(),
//                 onChanged: (value) => method = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select a method';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Booking Status: $bookingStatus',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     if (carLicense == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Please attach your car license.')),
//                       );
//                       return;
//                     }
//                     _formKey.currentState!.save();
//                     _logBookingDetails();

//                     _submitBooking(); // Add parentheses to call the function
//                   }
//                 },
//                 child: const Text('Submit Booking'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants.dart';
import 'BookingSuccessPage.dart';

// Future<void> _loginUser(String email, String password) async {
//   final url = Uri.http(backendUrl, /api/login');
//       final res = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'email': _enteredEmail,
//           'password': _enteredPass,
//         }),
//       );
//   final response = await http.post(
//     Uri.parse('$backendUrl/api/login'),
//     body: {'email': email, 'password': password},
//   );

//   if (response.statusCode == 200) {
//     final responseData = json.decode(response.body);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('user_id', responseData['user_id']); // Store user ID
//     // Navigate to the home page or another appropriate page
//   } else {
//     // Handle login error
//   }
// }

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> workshop;
  final int userid;
  const BookingPage({super.key, required this.workshop, required this.userid});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form fields
  String? customerName;
  String? phoneNumber;
  String? selectedService;
  String? problemDetails;
  DateTime? preferredDate;
  String? preferredTime;
  String? method;
  File? problemImageOrVideo;
  File? carLicense;

  // State variables
  bool _isLoading = false;
  List<String> _services = []; // List to store fetched services
  bool _isFetchingServices = true; // Loading state for services

  @override
  void initState() {
    _fetchServices(); // Fetch services when the page loads
    super.initState();
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

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _services =
              data.map((service) => service['name'].toString()).toList();
          _isFetchingServices = false;
        });
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      setState(() {
        _isFetchingServices = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load services: $e')),
      );
    }
  }

  Future<void> _pickImageOrVideo() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery) ??
        await _picker.pickVideo(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        problemImageOrVideo = File(file.path);
      });
    }
  }

  Future<void> _pickLicense() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        carLicense = File(file.path);
      });
    }
  }

  void _pickPreferredTime(BuildContext context) async {
    final List<String> timeSlots = [
      '8-9',
      '9-10',
      '10-11',
      '11-12',
      '12-1',
      '1-2',
      '2-3',
      '3-4',
      '4-5'
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(timeSlots[index]),
              onTap: () {
                setState(() {
                  preferredTime = timeSlots[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _submitBooking() async {
    // Dismiss the keyboard before validation
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    // Save form data
    _formKey.currentState!.save();

    // Check if user ID is available
    if (widget.userid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    // Debugging: Print all form field values
    print('Customer Name: $customerName');
    print('Phone Number: $phoneNumber');
    print('Selected Service: $selectedService');
    print('Preferred Date: $preferredDate');
    print('Preferred Time: $preferredTime');
    print('Method: $method');
    print('Car License: ${carLicense != null ? "Attached" : "Not Attached"}');

    // Check for null or empty values and print missing fields
    if (customerName == null || customerName!.isEmpty) {
      print('Customer Name is required');
    }
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      print('Phone Number is required');
    }
    if (selectedService == null || selectedService!.isEmpty) {
      print('Service is required');
    }
    if (preferredDate == null) {
      print('Preferred Date is required');
    }
    if (preferredTime == null || preferredTime!.isEmpty) {
      print('Preferred Time is required');
    }
    if (method == null || method!.isEmpty) {
      print('Method is required');
    }
    if (carLicense == null) {
      print('Car License is required');
    }

    // If any required field is missing, show a snackbar and return
    if (customerName == null ||
        customerName!.isEmpty ||
        phoneNumber == null ||
        phoneNumber!.isEmpty ||
        selectedService == null ||
        selectedService!.isEmpty ||
        preferredDate == null ||
        preferredTime == null ||
        preferredTime!.isEmpty ||
        method == null ||
        method!.isEmpty ||
        carLicense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    // Prepare the booking data
    final bookingData = {
      'customer_name': customerName,
      'mobile': phoneNumber,
      'service': selectedService,
      'problem_details': problemDetails,
      'preferred_date': preferredDate!.toIso8601String(),
      'preferred_time': preferredTime,
      'payment_method': method,
      'company_id': widget.workshop['id'],
      'user_id': prefs.getInt('userId')
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.http(backendUrl, '/api/bookings/create');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'customer_name': customerName,
          'mobile': phoneNumber,
          'service': selectedService,
          'problem_details': problemDetails,
          'preferred_date': preferredDate!.toIso8601String(),
          'preferred_time': preferredTime,
          'payment_method': method,
          'company_id': widget.workshop['id'],
          'user_id': prefs.getInt('userId')
        }),
      );

      //   Uri.parse('$backendUrl/api/bookings/create'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(bookingData),
      // );

      if (response.statusCode == 201) {
        // Booking created successfully
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );

        // Navigate to the Success Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingSuccessPage(
              bookingData: bookingData,
            ),
          ),
        );
      } else {
        // Handle errors
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit booking: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely handle null values for carBrands
    final List<String> carBrands = widget.workshop['carBrands'] is List
        ? List<String>.from(widget.workshop['carBrands'])
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Service'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => customerName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mobile Number Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => phoneNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Service Required Dropdown
              _isFetchingServices
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Service Required'),
                      items: _services.map((service) {
                        return DropdownMenuItem(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                      onChanged: (value) => selectedService = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a service';
                        }
                        return null;
                      },
                    ),
              const SizedBox(height: 16),

              // Problem Details Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Problem Details'),
                maxLines: 4,
                onSaved: (value) => problemDetails = value,
                validator: (value) {
                  // Optional field, no validation required
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Attach Problem Image/Video Button
              ElevatedButton(
                onPressed: _pickImageOrVideo,
                child: Text(problemImageOrVideo == null
                    ? 'Attach Problem Image/Video'
                    : 'File Attached'),
              ),
              if (problemImageOrVideo != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Attached File: ${problemImageOrVideo!.path.split('/').last}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
              const SizedBox(height: 16),

              // Attach Car License Button
              ElevatedButton(
                onPressed: _pickLicense,
                child: Text(carLicense == null
                    ? 'Attach Car License'
                    : 'License Attached'),
              ),
              if (carLicense != null) ...[
                const SizedBox(height: 8),
                Text(
                  'License File: ${carLicense!.path.split('/').last}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
              const SizedBox(height: 16),

              // Preferred Time Button
              ElevatedButton(
                onPressed: () => _pickPreferredTime(context),
                child: Text(preferredTime == null
                    ? 'Select Preferred Time'
                    : 'Selected Time: $preferredTime'),
              ),
              const SizedBox(height: 16),

              // Preferred Date Button
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      preferredDate = pickedDate;
                    });
                  }
                },
                child: Text(preferredDate == null
                    ? 'Pick Preferred Date'
                    : 'Selected Date: ${preferredDate!.toLocal()}'
                        .split(' ')[0]),
              ),
              const SizedBox(height: 16),

              // Method Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Method'),
                items: ['Pickup', 'Drop-off'].map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) => method = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitBooking,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
