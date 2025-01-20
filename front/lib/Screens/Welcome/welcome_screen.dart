import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../Login/login_screen.dart';
import '../Signup/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002b92), // Set background color
      body: Stack(
        children: [
          Column(
            children: [
              // Upper Widget: PageView for descriptions and features
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: const [
                    WelcomePage(
                      title: '',
                      description:
                          'Your all-in-one solution for car maintenance and services. Say goodbye to car troubles and hello to convenience!',
                    ),
                    WelcomePage(
                      title: 'Key Features',
                      description:
                          '• Find nearby car services\n• Book appointments instantly\n• Emergency Service at your doorstep\n• Real-time notifications and updates',
                    ),
                    WelcomePage(
                      title: 'More Features',
                      description:
                          '• Emergency roadside assistance\n• Tire repair and replacement\n• Shop for car parts\n• Real-time tracking of your car service\n• And much more!',
                    ),
                  ],
                ),
              ),

              // Lower Widget: Fixed Buttons and Page Indicators
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
                color: const Color(0xFF002b92), // Match background color
                child: Column(
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                        height: 20), // Spacing between indicators and buttons

                    // Sign In Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 19, 185),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize:
                            const Size(double.infinity, 20), // Full width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: defaultPadding), // Spacing between buttons

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the sign-up page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize:
                            const Size(double.infinity, 50), // Full width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 36, 19, 185),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 36, 19, 185),
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: defaultPadding), // Spacing before footer text
                    const Text(
                      'By continuing you agree to our Terms & Conditions & Privacy Policy',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 255, 254, 254),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Arrows for Navigation
          if (_currentPage > 0)
            Positioned(
              left: 20,
              bottom: 300, // Adjusted to avoid overlapping with buttons
              child: FloatingActionButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: const Color.fromARGB(255, 36, 19, 185),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          if (_currentPage < 2)
            Positioned(
              right: 20,
              bottom: 300, // Adjusted to avoid overlapping with buttons
              child: FloatingActionButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: const Color.fromARGB(255, 36, 19, 185),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String title;
  final String description;

  const WelcomePage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: defaultPadding * 2),
            const Text(
              "WELCOME TO Sayyarti",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding * 2),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Image.asset(
                    "assets/images/s.gif",
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: defaultPadding * 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Login Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
