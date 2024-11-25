import 'package:flutter/material.dart';
import '../home/adscroller.dart';
import '../home/testdrive.dart';
import 'carservivepage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search for products ..",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
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
                      "Test Drive",
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

              // car Section Title
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Aligns items to the left
                  children: [
                    // Section Title

                    const Text(
                      "Car Service",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between title and box
                    // Service Box
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 32, 11, 153)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Car Service",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 49, 15, 145),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const carservivepage()),
                              );
                            },
                            child: Container(
                              // Your widget content like a card or image
                              padding: const EdgeInsets.all(16.0),
                              child: const Text('Go to Car Service Page'),
                            ),
                          ),
                          const Text(
                            "Request the service at your doorstep",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/ss5.jpg',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                width: 50.0, // Size of the image
                height: 50.0, // Size of the image
                fit: BoxFit.cover, // Ensures the image covers its bounds
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color.fromARGB(255, 49, 87, 194),
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

  Widget _buildMainSectionBox(String title, String imagePath) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

  Widget _buildMainSectionBox(String title, String imagePath) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
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
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}

class MinorServicePage extends StatelessWidget {
  const MinorServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}

class OilChangePage extends StatelessWidget {
  const OilChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}

class BatteryPage extends StatelessWidget {
  const BatteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}

class InspectionPage extends StatelessWidget {
  const InspectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Car Wash')),
        body: const Center(child: Text("Car Wash Page")));
  }
}
