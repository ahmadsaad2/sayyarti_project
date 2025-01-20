import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'BookingSuccessPage.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> workshop;

  const BookingPage({super.key, required this.workshop});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  String? customerName;
  String? phoneNumber;
  String? selectedService;
  String? problemDetails;
  DateTime? preferredDate;
  String? preferredTime;
  String? method;
  String? bookingStatus = "Pending";

  File? problemImageOrVideo;
  File? carLicense;
  final ImagePicker _picker = ImagePicker();

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

  void _logBookingDetails() {
    print("Booking Details:");
    print("Name: $customerName");
    print("Mobile Number: $phoneNumber");
    print("Service Required: $selectedService");
    print("Problem Details: $problemDetails");
    print(
        "Preferred Date: ${preferredDate?.toLocal().toString().split(' ')[0]}");
    print("Preferred Time: $preferredTime");
    print("Method: $method");
    print("Booking Status: $bookingStatus");
    print(
        "Problem Image/Video: ${problemImageOrVideo?.path ?? 'Not attached'}");
    print("Car License: ${carLicense?.path ?? 'Not attached'}");
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (carLicense == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please attach your car license.')),
        );
        return;
      }

      // Check for null values
      if (customerName == null ||
          selectedService == null ||
          preferredDate == null ||
          preferredTime == null ||
          method == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields.')),
        );
        return;
      }

      // Save form data
      _formKey.currentState!.save();

      // Create a Map to store booking details
      final bookingData = {
        'customerName': customerName,
        'phoneNumber': phoneNumber,
        'selectedService': selectedService,
        'problemDetails': problemDetails,
        'preferredDate': preferredDate,
        'preferredTime': preferredTime,
        'method': method,
      };

      // Navigate to Success Page and pass the booking data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSuccessPage(
            bookingData: bookingData,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Service Required'),
                items: (widget.workshop['services'] as List<String>)
                    .map((service) {
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Problem Details'),
                maxLines: 4,
                onSaved: (value) => problemDetails = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide details about the problem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: () => _pickPreferredTime(context),
                child: Text(preferredTime == null
                    ? 'Select Preferred Time'
                    : 'Selected Time: $preferredTime'),
              ),
              const SizedBox(height: 16),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Booking Status: $bookingStatus',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (carLicense == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please attach your car license.')),
                      );
                      return;
                    }
                    _formKey.currentState!.save();
                    _logBookingDetails();

                    _submitBooking(); // Add parentheses to call the function
                  }
                },
                child: const Text('Submit Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
