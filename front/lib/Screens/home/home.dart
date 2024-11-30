// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../home/adscroller.dart';
import '../home/testdrive.dart';
import 'adpage.dart';
import 'account/profile.dart';
import 'account/addresspage.dart';
import 'appcontact/contactus.dart';
import 'appcontact/terms.dart';
import 'account/deleteaccount.dart';
import 'account/mycar.dart';
import '../Welcome/welcome_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Function to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle the navigation to different pages
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BasketPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MorePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set text direction to RTL
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove the back button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  // Image.asset(
                  //   'assets/icons/4.jpg', // Add your logo
                  //   height: 30,
                  // ),

                  SizedBox(width: 8),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Text(
                    "Sayyarti",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 20.0, right: 20),
                icon: Image.asset(
                  'assets/images/cs.png', // Path to your image
                  width: 30.0, // Set the width of the image
                  height: 30.0, // Set the height of the image
                  fit: BoxFit.cover,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.only(
                        left: 30,
                      ),
                      suffixIcon: const Padding(
                        padding: EdgeInsets.only(right: 24.0, left: 16.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // AdsScroller
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const AdsScroller(),
              ),

              // New Section: Car Services
              const Padding(
                padding: EdgeInsets.only(top: 20.0, right: 100.0, bottom: 20),
                child: Text(
                  "Services for Your Car",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4, // 4 columns
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildServiceBox(context, "Fuel", "assets/images/fuel.png",
                      const FuelPage()),
                  _buildServiceBox(context, "Car Wash",
                      "assets/images/wash.png", const CarWashPage()),
                  _buildServiceBox(context, "Battery",
                      "assets/images/battary.png", const BatteryPage()),
                  _buildServiceBox(context, "Tyres", "assets/images/tryy.png",
                      const TyresPage()),
                  _buildServiceBox(context, "Minor Service",
                      "assets/images/oil.png", const MinorServicePage()),
                  _buildServiceBox(context, "Electbattar",
                      "assets/images/elect.png", const InspectionPage()),
                  _buildServiceBox(context, "Oil Change",
                      "assets/images/oil.png", const OilChangePage()),
                  GestureDetector(
                    onTap: () => _showEmergencyServices(context),
                    child: _buildServiceBoxWithImage(
                        "Emergency", "assets/images/emer.png"),
                  ),
                ],
              ),

              // Test Drive Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Rent Car",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Add spacing between title and container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 59, 57, 201)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          const TestDriveSection(), // Include your TestDriveSection here
                    ),
                  ],
                ),
              ),
              // Main Section Title
              const Padding(
                padding: EdgeInsets.only(right: 150.0, top: 20.0),
                child: Text(
                  " Car Part ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Main Sections Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  _buildMainSectionBox('Spare Parts', 'assets/images/part.jpg'),
                  _buildMainSectionBox("Battery", 'assets/images/battry.jpg'),
                  _buildMainSectionBox("Wheels", 'assets/images/wheel.jpg'),
                  _buildMainSectionBox("Accessories", 'assets/images/accs.jpg'),
                  _buildMainSectionBox(
                      "Regular Maintenance", 'assets/images/oil.jpg'),
                  _buildAllProductsBox(context),
                ],
              ),
              const SizedBox(height: 20), // Ad Box
              // Ad Box
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdDetailsPage(
                          imagePath: 'assets/images/sa.JPG',
                          adTitle: 'Fuel Delivery',
                          adDescription:
                              'Fuel delivered 24/7; same price as the petrol station.',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200, // Adjust height to make it larger
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/sa.JPG', // Replace with your image path
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),

                        // Overlay Gradient
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),

                        // Ad Content
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            textDirection: TextDirection
                                .rtl, // Default, ensures alignment respects LTR

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Content (e.g., Delivery Type)

                              // Main Content
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .end, // Align items to the right
                                textDirection: TextDirection.ltr,
                                children: [
                                  const SizedBox(height: 52),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 227, 225, 241),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      "15% off your first order!",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //message icon
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              bottom: 80.0,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/cha.png', // Path to your image
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color.fromARGB(255, 49, 87, 194),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/home.png')),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/order.png')),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/add-to-cart.png')),
              label: "Basket",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/application.png')),
              label: "More",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllProductsBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllProductsPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apps, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "All Products",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          _buildMainSectionBox('Spare Parts', 'assets/images/part.jpg'),
          _buildMainSectionBox("Battery", 'assets/images/battry.jpg'),
          _buildMainSectionBox("Wheels", 'assets/images/wheel.jpg'),
          _buildMainSectionBox("Accessories", 'assets/images/accs.jpg'),
          _buildMainSectionBox("Regular Maintenance", 'assets/images/oil.jpg'),
        ],
      ),
    );
  }
}

Widget _buildMainSectionBox(String title, String imagePath) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Colors.white, // Background color
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(2, 2), // Shadow position
        ),
      ],
    ),
    padding: const EdgeInsets.all(4.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Header Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 7, 5, 5),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        // 3D Image with box shadow for depth
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(4, 4), // Adds 3D-like depth
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildServiceBox(
    BuildContext context, String title, String imagePath, Widget nextPage) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 2), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 7, 5, 5),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          // 3D Image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(4, 4), // Adds 3D-like depth
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Function to create a service box for Emergency
Widget _buildServiceBoxWithImage(String title, String imagePath) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(imagePath, height: 40.0, width: 40.0, fit: BoxFit.cover),
      const SizedBox(height: 8.0),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ],
  );
}

// Emergency Services Bottom Sheet
void _showEmergencyServices(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Emergency Services",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEmergencyOption("Jump Start", "assets/images/jmp.png"),
                _buildEmergencyOption("Tyre Change", "assets/images/rep.png"),
                _buildEmergencyOption(
                    "Tyre Pressure", "assets/images/tryy.png"),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// Function to create an emergency service option
Widget _buildEmergencyOption(String title, String imagePath) {
  return Column(
    children: [
      Image.asset(imagePath, height: 40.0, width: 40.0, fit: BoxFit.cover),
      const SizedBox(height: 8.0),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

// Dummy Pages for Navigation
class FuelPage extends StatelessWidget {
  const FuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Fuel Service')),
        body: const Center(child: Text("Fuel Service Page")));
  }
}

class CarWashPage extends StatelessWidget {
  const CarWashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}

class TyresPage extends StatelessWidget {
  const TyresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tyres Service')),
        body: const Center(child: Text("Tyres Service Page")));
  }
}

class MinorServicePage extends StatelessWidget {
  const MinorServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Minor Service')),
        body: const Center(child: Text("Minor Service Page")));
  }
}

class OilChangePage extends StatelessWidget {
  const OilChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Oil Change')),
        body: const Center(child: Text("Oil Change Page")));
  }
}

class BatteryPage extends StatelessWidget {
  const BatteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Battery Service')),
        body: const Center(child: Text("Battery Service Page")));
  }
}

class InspectionPage extends StatelessWidget {
  const InspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Inspection Service')),
        body: const Center(child: Text("Inspection Service Page")));
  }
}

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    String userName = 'User Name';
    int point = 0;
    String firstLetter = userName.isNotEmpty
        ? userName[0].toUpperCase()
        : ''; // Get the first letter

    return Scaffold(
      appBar: AppBar(
        title: const Text('More '),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color.fromARGB(255, 15, 72, 158),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 29, 59, 197),
                    child: Text(
                      firstLetter, // Display the first letter as profile picture
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('$point Point'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
            // My Account Section
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_rental),
              title: const Text('My Cars'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCarsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                );
              },
            ),
            // Settings Section

            ListTile(
              title: const Text('Language'),
              trailing: const Text('English'),
              onTap: () {}, // Implement onTap logic here
            ),
            // Contact Us Section

            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact us'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.terminal_sharp),
              title: const Text('Terms and conditions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const Center(child: Text("This is the Orders Page")),
    );
  }
}

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basket')),
      body: const Center(child: Text("This is the Basket Page")),
    );
  }
}
