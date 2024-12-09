import 'package:flutter/material.dart';

class ServiceCenterHomePage extends StatelessWidget {
  // Dummy data
  final String garageName = 'Auto Care Center';
  final String location = 'Nablus';
  final String contact = '123-456-7890';
  final String details = 'Expert in car repairs and maintenance.';
  final String imagePath = 'assets/images/5.jpg'; // Placeholder image path
  final int employeeCount = 20;
  final double totalRevenue = 15000.0;
  final double cashFlow = 5000.0;

  const ServiceCenterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Dashboard'),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 11, 42, 146),
      ),
      drawer: const CustomDrawer(), // The sidebar (drawer) that slides in
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garage Info Box (Editable)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: const Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/sdd.jpg'), // Garage Image
                    radius: 30,
                  ),
                  title: Text('Auto Care Center'),
                  subtitle: Text('Tap to Edit Profile'),
                  trailing: Icon(Icons.edit),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Employee Stats Box (Editable)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmployeePage()),
                );
              },
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/5.jpg'), // Employee Image
                    radius: 30,
                  ),
                  title: Text('Employees: $employeeCount'),
                  subtitle: const Text('Tap to Manage Employees'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Revenue Stats (Bar Graph)
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Revenue & Cash Flow',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Color.fromARGB(255, 22, 72, 165)),
                        const SizedBox(width: 10),
                        Text(
                            'Total Revenue: \$${totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: totalRevenue / 100000,
                      color: const Color.fromARGB(255, 21, 73, 170),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text('Cash Flow: \$${cashFlow.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Services Offered (Editable)
            const Text('Services Offered',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Car Fixing',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text(
                        'The main service we offer is repairing and fixing all car types, from basic fixes to complex engine work.'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Edit Services Page
                      },
                      child: const Text('Edit Service'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Packages (Editable)
            const Text('Service Packages',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }
}

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
              // Close drawer and navigate to Dashboard
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: 'Profile',
            icon: Icons.account_circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
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
          DrawerListTile(
            title: 'Services',
            icon: Icons.build,
            onTap: () {
              // Navigate to Services Page
            },
          ),
          DrawerListTile(
            title: 'Packages',
            icon: Icons.card_giftcard,
            onTap: () {
              // Navigate to Packages Page
            },
          ),
          DrawerListTile(
            title: 'Revenue',
            icon: Icons.attach_money,
            onTap: () {
              // Navigate to Revenue Page
            },
          ),
        ],
      ),
    );
  }
}

// Left Sidebar List Tile
class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const DrawerListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 23, 38, 180)),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}

// Service Package Card (Editable)
class ServicePackageCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final Function onEdit;

  const ServicePackageCard(
      {super.key,
      required this.title,
      required this.description,
      required this.price,
      required this.onEdit});

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
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 10),
            Text('Price: \$${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onEdit(),
              child: const Text('Edit Package'),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Page (Edit Profile)
class ProfilePage extends StatelessWidget {
  final TextEditingController _garageNameController =
      TextEditingController(text: 'Auto Care Center');
  final TextEditingController _locationController =
      TextEditingController(text: 'Nablus');
  final TextEditingController _contactController =
      TextEditingController(text: '123-456-7890');
  final TextEditingController _detailsController =
      TextEditingController(text: 'Expert in car repairs and maintenance.');

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/sdd.jpg'), // Profile Image
              radius: 60,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _garageNameController,
              decoration: const InputDecoration(labelText: 'Garage Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact Info'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(labelText: 'Details'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save Profile Changes
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

// Employee Page (Manage Employees)
class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Employees')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Employee Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Employee Role'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save Employee Changes
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
