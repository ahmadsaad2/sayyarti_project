import 'package:flutter/material.dart';
import '../class/employeclass.dart';

class ProfilePage extends StatefulWidget {
  final Employee employee;

  const ProfilePage({super.key, required this.employee});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current employee details
    _nameController = TextEditingController(text: widget.employee.name);
    _positionController = TextEditingController(text: widget.employee.position);
    _emailController = TextEditingController(text: widget.employee.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      widget.employee.name = _nameController.text;
      widget.employee.position = _positionController.text;
      widget.employee.email = _emailController.text;
    });
    Navigator.pop(context); // Go back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
