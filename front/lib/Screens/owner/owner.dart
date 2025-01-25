import 'package:flutter/material.dart';
import 'porfile.dart';
import 'employee.dart';
import 'servicegrage.dart';
import '../booking_owner/bookingpage.dart';
import 'offers.dart';
import 'review.dart';
import 'faqpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model for company profile
class CompanyProfile {
  final int? id;
  final String? name;
  final String? address;
  final String? contact;
  final String? email;
  final String? image;
  final int? userId;

  CompanyProfile({
    this.id,
    this.name,
    this.address,
    this.contact,
    this.email,
    this.image,
    this.userId,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      userId: json['user_id'] as int?,
    );
  }
}

// Fetch company profile from the backend
Future<CompanyProfile> fetchCompanyProfile(int userId) async {
  final response = await http.get(
    Uri.parse('http://192.168.88.4:5000/api/company/user/$userId'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final companyJson = data['company'];
    return CompanyProfile.fromJson(companyJson);
  } else {
    throw Exception('Failed to load company profile');
  }
}

class ServiceCenterHomePage extends StatefulWidget {
  final int userId;

  const ServiceCenterHomePage({super.key, required this.userId});

  @override
  _ServiceCenterHomePageState createState() => _ServiceCenterHomePageState();
}

class _ServiceCenterHomePageState extends State<ServiceCenterHomePage> {
  final List<Map<String, String>> bookings = [
    {
      "Customer": "John Doe",
      "Mobile": "1234567890",
      "Service": "Car Wash",
      "Time": "10:00 AM",
      "Payment": "Paid",
      "Status": "Confirmed"
    },
    {
      "Customer": "Jane Smith",
      "Mobile": "0987654321",
      "Service": "Polishing",
      "Time": "12:00 PM",
      "Payment": "Pending",
      "Status": "Pending"
    }
  ];

  late Future<CompanyProfile> futureCompanyProfile;

  @override
  void initState() {
    super.initState();
    futureCompanyProfile = fetchCompanyProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanyProfile>(
      future: futureCompanyProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('No company data found')),
          );
        }

        final company = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Garage Dashboard',
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 11, 42, 146),
            elevation: 0,
          ),
          drawer: CustomDrawer(
            userId: widget.userId,
            companyId: company.id!,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(context, company),
                const SizedBox(height: 20),
                _buildEmployeeSection(context, company.id!),
                const SizedBox(height: 20),
                _buildBookingsSection(context),
                const SizedBox(height: 20),
                _buildServicesSection(context, company.id!),
                const SizedBox(height: 20),
                _buildOffersSection(context, company.id!),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(BuildContext context, CompanyProfile company) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userId: widget.userId),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: company.image != null
                    ? NetworkImage(company.image!) as ImageProvider
                    : const AssetImage('assets/images/sdd.jpg'),
                radius: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage your company profile, update details, and view insights.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeSection(BuildContext context, int companyId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeePage(companyId: companyId),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.group, color: Colors.blue, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manage Employees',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'View, add, or remove employees. Manage roles and permissions.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Bookings",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'View and manage all bookings scheduled for today. Confirm, reschedule, or cancel appointments as needed.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        bookings.isEmpty
            ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.orange[100],
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No Bookings Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              )
            : Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
                    rows: bookings.asMap().entries.map((entry) {
                      final index = entry.key;
                      final booking = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(booking['Customer'] ?? '')),
                          DataCell(Text(booking['Mobile'] ?? '')),
                          DataCell(Text(booking['Service'] ?? '')),
                          DataCell(Text(booking['Time'] ?? '')),
                          DataCell(Text(booking['Payment'] ?? '')),
                          DataCell(Text(booking['Status'] ?? '')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit action
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context, int companyId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services Offered',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Explore and manage the services your company offers. Add new services or update existing ones to meet customer needs.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Car Repair & Maintenance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We specialize in repairing and maintaining all types of vehicles. From oil changes to engine overhauls, we’ve got you covered.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServicesPage(companyId: companyId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit Services',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffersSection(BuildContext context, int companyId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Offers',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Create and manage special offers to attract more customers. Update discounts, promotions, and seasonal deals.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Offers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'No active offers at the moment. Tap below to create new offers.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OffersPage(companyId: companyId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Manage Offers',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Drawer
class CustomDrawer extends StatelessWidget {
  final int userId;
  final int companyId;

  const CustomDrawer({
    super.key,
    required this.userId,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 16, 59, 177),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/5.jpg'),
                  radius: 30,
                ),
                SizedBox(height: 10),
                Text('Auto Care Center',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Nablus, Palestine',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          DrawerListTile(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: 'Profile',
            icon: Icons.account_circle,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: userId),
                  ));
            },
          ),
          DrawerListTile(
            title: 'Employees',
            icon: Icons.people,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeePage(companyId: companyId),
                  ));
            },
          ),
          DrawerListTile(
            title: 'Bookings',
            icon: Icons.book_online,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingsPage(companyId: companyId)),
              );
            },
          ),
          DrawerListTile(
            title: 'Services',
            icon: Icons.build,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServicesPage(companyId: companyId),
                ),
              );
            },
          ),
          DrawerListTile(
            title: 'Offers',
            icon: Icons.local_offer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OffersPage(companyId: companyId),
                ),
              );
            },
          ),
          DrawerListTile(
            title: 'Reviews',
            icon: Icons.star,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsPage(companyId: companyId)),
              );
            },
          ),
          DrawerListTile(
            title: 'FaQ',
            icon: Icons.question_answer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Reusable ListTile for drawer
class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 23, 38, 180)),
      title: Text(title),
      onTap: onTap,
    );
  }
}
