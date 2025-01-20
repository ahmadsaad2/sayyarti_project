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

class ServiceCenterHomePage extends StatelessWidget {
  final String garageName = 'Auto Care Center';
  final String location = 'Nablus';
  final String contact = '123-456-7890';
  final String details = 'Expert in car repairs and maintenance.';
  final String imagePath = 'assets/images/5.jpg'; // Placeholder image path

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

  ServiceCenterHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Dashboard'),
        backgroundColor: const Color.fromARGB(255, 11, 42, 146),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 20),
            _buildEmployeeSection(context),
            const SizedBox(height: 20),
            _buildBookingsSection(context),
            const SizedBox(height: 20),
            _buildServicesSection(context),
            const SizedBox(height: 20),
            // _buildServicePackagesSection(),
            _buildOffersSection(context), //
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      },
      child: const Card(
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/sdd.jpg'),
            radius: 30,
          ),
          title: Text('Auto Care Center'),
          subtitle: Text('Tap to Edit Profile'),
          trailing: Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget _buildEmployeeSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmployeePage()),
        );
      },
      child: const Card(
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/5.jpg'),
            radius: 30,
          ),
          title: Text('Employees'),
          subtitle: Text('Tap to Manage Employees'),
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
  const CustomDrawer({super.key});

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
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          DrawerListTile(
            title: 'Employees',
            icon: Icons.people,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmployeePage()),
              );
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
