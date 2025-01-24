// this page for compony owner (grage owner)
import 'package:flutter/material.dart';
import 'porfile.dart';
import 'employee.dart';
import 'servicegrage.dart';
import '../booking_owner/bookingpage.dart';
import 'offers.dart';
import 'review.dart';
import 'faqpage.dart';
import '../class/offermanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<CompanyProfile> fetchCompanyProfile(int userId) async {
  final response = await http.get(
    Uri.parse('http://192.168.88.4:5000/api/company/user/$userId'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final companyJson = data['company']; // Extract the nested object
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Dashboard'),
        backgroundColor: const Color.fromARGB(255, 11, 42, 146),
      ),
      drawer: CustomDrawer(userId: widget.userId),
      body: FutureBuilder<CompanyProfile>(
        future: futureCompanyProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No company data found'));
          }

          final company = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(context, company),
                const SizedBox(height: 20),
                _buildEmployeeSection(
                    context, company.id!), // Pass companyId here
                const SizedBox(height: 20),
                _buildBookingsSection(context),
                const SizedBox(height: 20),
                _buildServicesSection(context),
                const SizedBox(height: 20),
                _buildOffersSection(context),
              ],
            ),
          );
        },
      ),
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
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: company.image != null
                ? NetworkImage(company.image!) as ImageProvider
                : const AssetImage('assets/images/sdd.jpg'),
            radius: 30,
          ),
          title: Text(company.name ?? 'No Name'),
          subtitle: const Text('Tap to Edit Profile'),
          trailing: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _buildEmployeeSection(BuildContext context, int companyId) {
    return GestureDetector(
      onTap: () {
        // Navigate to EmployeePage with the provided companyId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeePage(companyId: companyId),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.group, color: Colors.blue),
          title: const Text('Manage Employees'),
          subtitle:
              const Text('View and manage employees working in this company'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }

  Widget _buildOffersSection(BuildContext context) {
    final offers = OffersManager.instance.offers; // Fetch offers from manager

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Offers",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        offers.isEmpty
            ? Card(
                color: Colors.orange[100],
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No Offers Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('description')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Minimum Spend')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                  ],
                  rows: offers
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text((entry.key + 1).toString())),
                            DataCell(Text(entry.value['description'] ?? '')),
                            DataCell(Text(entry.value['Type'] ?? '')),
                            DataCell(Text(entry.value['Amount'] ?? '')),
                            DataCell(Text(entry.value['Minimum'] ?? '')),
                            DataCell(Text(entry.value['Start'] ?? '')),
                            DataCell(Text(entry.value['End'] ?? '')),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
      ],
    );
  }

  Widget _buildBookingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Bookings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        bookings.isEmpty
            ? Card(
                color: Colors.orange[100],
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No Bookings Today',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : SingleChildScrollView(
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
                  rows: bookings
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text((entry.key + 1).toString())),
                            DataCell(Text(entry.value['Customer'] ?? '')),
                            DataCell(Text(entry.value['Mobile'] ?? '')),
                            DataCell(Text(entry.value['Service'] ?? '')),
                            DataCell(Text(entry.value['Time'] ?? '')),
                            DataCell(Text(entry.value['Payment'] ?? '')),
                            DataCell(Text(entry.value['Status'] ?? '')),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit action
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services Offered',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Car Fixing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The main service we offer is repairing and fixing all car types, from basic fixes to complex engine work.',
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServicesPage()),
                    );
                  },
                  child: const Text('Edit Service'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicePackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Packages',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ServicePackageCard(
          title: 'Basic',
          description: 'Complete Car Exterior Cleaning',
          price: 35,
          onEdit: () {
            // Navigate to edit package
          },
        ),
        ServicePackageCard(
          title: 'Advanced',
          description: 'Complete Car Exterior Cleaning & Interior',
          price: 105,
          onEdit: () {
            // Navigate to edit package
          },
        ),
      ],
    );
  }
}

// Other widgets like `CustomDrawer`, `ServicePackageCard`, etc., remain the same.
// Left Sidebar (Drawer) widget
class CustomDrawer extends StatelessWidget {
  final int userId;

  const CustomDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with garage image
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

          // Sidebar Items
          DrawerListTile(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () {
              Navigator.pop(context); // Close drawer
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(          builder: (context) => EmployeePage(companyId: companyId!),

              // ));
            },
          ),

          // New: Bookings Page
          DrawerListTile(
            title: 'Bookings',
            icon: Icons.book_online,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingsPage()),
              );
            },
          ),

          // New: Services Page
          DrawerListTile(
            title: 'Services',
            icon: Icons.build,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicesPage()),
              );
            },
          ),

          // New: Offers Page
          DrawerListTile(
            title: 'Offers',
            icon: Icons.local_offer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OffersPage()),
              );
            },
          ),

          // New: Reviews Page
          DrawerListTile(
            title: 'Reviews',
            icon: Icons.star,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewsPage()),
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

// Sidebar List Tile Component
class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

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
      onTap: () => onTap(),
    );
  }
}

class ServicePackageCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final VoidCallback onEdit;

  const ServicePackageCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 10),
            Text(
              'Price: \$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onEdit,
              child: const Text('Edit Package'),
            ),
          ],
        ),
      ),
    );
  }
}
