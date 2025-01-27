import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/Login/login_screen.dart';
import 'package:sayyarti/Screens/admin/screens/add_company.dart';
import 'package:sayyarti/Screens/admin/screens/add_product.dart';
import 'package:sayyarti/Screens/admin/screens/create_company_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: DrawerHeader(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 49, 87, 194),
                      const Color.fromARGB(255, 49, 87, 194)
                          .withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.assignment_ind_outlined,
                      size: 45,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Admin actions',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.domain_add,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Add new company',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddCompanyScreen()));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Create company admin',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const CreateCompanyAdminScreen()));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Add a Product',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddProductScreen()));
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
