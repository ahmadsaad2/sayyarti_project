import 'package:flutter/material.dart';

class CreateCompanyAdminScreen extends StatefulWidget {
  const CreateCompanyAdminScreen({super.key});

  @override
  State<CreateCompanyAdminScreen> createState() {
    return _CreateCompanyAdminScreenState();
  }
}

class _CreateCompanyAdminScreenState extends State<CreateCompanyAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create company admin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 49, 87, 194),
          centerTitle: true,
        ),
      ),
    );
  }
}
