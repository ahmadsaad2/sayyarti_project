import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/admin/widgets/admin_drawer.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 49, 87, 194),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: const Center(
            child:
                Text('statistic data and other features related to the admin')),
      ),
    );
  }
}
