import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      required String location,
      required String contact,
      required String garageName,
      required String details})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _garageName = 'Auto Care Center';
  String _location = 'Nablus';
  String _details = 'Expert in car repairs and maintenance.';
  String _contact = '123-456-789';

  // Function to handle form submission (saving the changes)
  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save the changes to the database or locally
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 8, 75, 219),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Garage Name Field
              TextFormField(
                initialValue: _garageName,
                decoration: const InputDecoration(labelText: 'Garage Name'),
                onChanged: (value) => _garageName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the garage name';
                  }
                  return null;
                },
              ),
              // Location Field
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => _location = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              // Details Field
              TextFormField(
                initialValue: _details,
                decoration: const InputDecoration(labelText: 'Details'),
                onChanged: (value) => _details = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              // Contact Field
              TextFormField(
                initialValue: _contact,
                decoration: const InputDecoration(labelText: 'Contact'),
                onChanged: (value) => _contact = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  return null;
                },
              ),
              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
