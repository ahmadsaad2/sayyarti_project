import 'package:flutter/material.dart';
import 'BookingDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingsPage extends StatefulWidget {
  final int companyId; // Accept company ID as a parameter

  const BookingsPage({super.key, required this.companyId});

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _fetchEmployees();
  }

  Future<void> _fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.88.4:5000/api/bookings?companyId=${widget.companyId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bookings: $error')),
      );
    }
  }

  Future<void> _fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.88.4:5000/api/employee/by-company/${widget.companyId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          employees =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching employees: $error')),
      );
    }
  }

  void _editBooking(int index) async {
    final updatedBooking = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsPage(booking: bookings[index]),
      ),
    );

    if (updatedBooking != null) {
      setState(() {
        bookings[index] = updatedBooking;
      });
    }
  }

  // void _assignTask(int bookingIndex) {
  //   final booking = bookings[bookingIndex];
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       int? selectedEmployeeId;
  //       String selectedDay = 'Monday';

  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             DropdownButtonFormField<int>(
  //               value: selectedEmployeeId, // Ensure this is an int
  //               onChanged: (newValue) {
  //                 setState(() {
  //                   selectedEmployeeId = newValue; // Update the selected value
  //                 });
  //               },
  //               items: employees
  //                   .map((employee) => DropdownMenuItem<int>(
  //                         value: employee['id'] as int, // Cast ID to int
  //                         child: Text(employee['name']
  //                             as String), // Cast name to String
  //                       ))
  //                   .toList(),
  //               decoration: const InputDecoration(
  //                 labelText: 'Select Employee',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             DropdownButtonFormField<String>(
  //               value: selectedDay,
  //               onChanged: (value) => setState(() {
  //                 selectedDay = value!;
  //               }),
  //               items: [
  //                 'Monday',
  //                 'Tuesday',
  //                 'Wednesday',
  //                 'Thursday',
  //                 'Friday',
  //                 'Saturday',
  //                 'Sunday'
  //               ]
  //                   .map((day) => DropdownMenuItem(
  //                         value: day,
  //                         child: Text(day),
  //                       ))
  //                   .toList(),
  //               decoration: const InputDecoration(
  //                 labelText: 'Day',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 if (selectedEmployeeId == null) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                         content: Text('Please select an employee')),
  //                   );
  //                   return;
  //                 }

  //                 try {
  //                   final response = await http.post(
  //                     Uri.parse(
  //                         'http://192.168.88.4:5000/api/bookings/assign-to-task/${booking['id']}'),
  //                     headers: {'Content-Type': 'application/json'},
  //                     body: json.encode({
  //                       'employeeId': selectedEmployeeId,
  //                       'day': selectedDay,
  //                     }),
  //                   );

  //                   if (response.statusCode == 201) {
  //                     Navigator.pop(context);
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                           content: Text('Task assigned successfully')),
  //                     );
  //                   } else {
  //                     throw Exception('Failed to assign task');
  //                   }
  //                 } catch (error) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(content: Text('Error assigning task: $error')),
  //                   );
  //                 }
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color.fromARGB(255, 1, 24, 126),
  //                 padding: const EdgeInsets.symmetric(vertical: 16),
  //               ),
  //               child:
  //                   const Text('Assign Task', style: TextStyle(fontSize: 18)),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _assignTask(int bookingIndex) {
    final booking = bookings[bookingIndex];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int? selectedEmployeeId;
        String selectedDay = 'Monday';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedEmployeeId, // Ensure this is an int
                onChanged: (newValue) {
                  setState(() {
                    selectedEmployeeId = newValue; // Update the selected value
                  });
                },
                items: employees
                    .map((employee) => DropdownMenuItem<int>(
                          value: employee['id'] as int, // Cast ID to int
                          child: Text(employee['name']
                              as String), // Cast name to String
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Select Employee',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDay,
                onChanged: (value) => setState(() {
                  selectedDay = value!;
                }),
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ]
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (selectedEmployeeId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select an employee')),
                    );
                    return;
                  }

                  // Find the selected employee to get the user_id
                  final selectedEmployee = employees.firstWhere(
                    (employee) => employee['id'] == selectedEmployeeId,
                  );

                  final userId = selectedEmployee[
                      'user_id']; // Get user_id from the employee

                  try {
                    final response = await http.post(
                      Uri.parse(
                          'http://192.168.88.4:5000/api/bookings/assign-to-task/${booking['id']}'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'employeeId': selectedEmployeeId,
                        'day': selectedDay,
                        'userId': userId, // Include user_id in the request body
                      }),
                    );

                    if (response.statusCode == 201) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Task assigned successfully')),
                      );
                    } else {
                      throw Exception('Failed to assign task');
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error assigning task: $error')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 24, 126),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    const Text('Assign Task', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Mobile')),
                    DataColumn(label: Text('Service')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Payment')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: bookings.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final booking = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(booking['customer_name'] ?? '')),
                          DataCell(Text(booking['mobile'] ?? '')),
                          DataCell(Text(booking['service'] ?? '')),
                          DataCell(Text(booking['booking_date'] ?? '')),
                          DataCell(Text(booking['payment_method'] ?? '')),
                          DataCell(Text(booking['status'] ?? '')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Color.fromARGB(255, 6, 25, 136)),
                                  onPressed: () => _editBooking(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.assignment,
                                      color: Color.fromARGB(255, 3, 38, 155)),
                                  onPressed: () => _assignTask(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
    );
  }
}
