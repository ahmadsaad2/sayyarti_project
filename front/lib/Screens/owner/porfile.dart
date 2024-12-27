import 'dart:io'; // For File handling
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images

class GarageProfile {
  String garageName;
  String location;
  String contact;
  String details;
  String ownerName;
  String ownerContact;
  String? imagePath;

  GarageProfile({
    required this.garageName,
    required this.location,
    required this.contact,
    required this.details,
    required this.ownerName,
    required this.ownerContact,
    this.imagePath, // Optional for garage image
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GarageProfile profile = GarageProfile(
    garageName: 'Auto Care Center',
    location: 'Nablus',
    contact: '123-456-7890',
    details: 'Expert in car repairs and maintenance.',
    ownerName: 'John Doe',
    ownerContact: '098-765-4321',
    imagePath: null, // No image initially
  );

  final TextEditingController _garageNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerContactController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with profile data
    _garageNameController.text = profile.garageName;
    _locationController.text = profile.location;
    _contactController.text = profile.contact;
    _detailsController.text = profile.details;
    _ownerNameController.text = profile.ownerName;
    _ownerContactController.text = profile.ownerContact;
  }

  Future<void> _changeImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profile.imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Garage Image Section
              Center(
                child: GestureDetector(
                  onTap: _changeImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profile.imagePath != null
                        ? FileImage(File(profile.imagePath!)) as ImageProvider
                        : const AssetImage(
                            'assets/images/default_garage.png'), // Default image
                    child: profile.imagePath == null
                        ? const Icon(Icons.camera_alt,
                            size: 30, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _garageNameController,
                decoration: const InputDecoration(
                  labelText: 'Garage Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter garage name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ownerContactController,
                decoration: const InputDecoration(
                  labelText: 'Owner Contact',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter owner contact';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      profile.garageName = _garageNameController.text;
                      profile.location = _locationController.text;
                      profile.contact = _contactController.text;
                      profile.details = _detailsController.text;
                      profile.ownerName = _ownerNameController.text;
                      profile.ownerContact = _ownerContactController.text;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saving profile changes')),
                    );
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
