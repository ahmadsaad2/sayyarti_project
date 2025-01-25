import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyProfile {
  final int? id;
  final String? name;
  final String? address;
  final String? contact;
  final String? email;
  final String? image;
  final int? userId;

  CompanyProfile({
    this.id,
    this.name,
    this.address,
    this.contact,
    this.email,
    this.image,
    this.userId,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      userId: json['user_id'] as int?,
    );
  }
}

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<CompanyProfile?> futureCompanyProfile;
  final _formKey = GlobalKey<FormState>();

  late String _name = '';
  late String _address = '';
  late String _contact = '';
  late String _email = '';

  @override
  void initState() {
    super.initState();
    futureCompanyProfile = fetchCompanyProfile(widget.userId);
  }

  Future<CompanyProfile?> fetchCompanyProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.88.4:5000/api/company/user/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['company'];
        return CompanyProfile.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // No company found
      } else {
        throw Exception(
            'Failed to load company profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load company profile: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final companyData = {
      'name': _name,
      'address': _address,
      'contact': _contact,
      'email': _email,
      'user_id': widget.userId,
    };

    try {
      final url = 'http://192.168.88.4:5000/api/company/user/${widget.userId}';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(companyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company Profile'),
      ),
      body: FutureBuilder<CompanyProfile?>(
        future: futureCompanyProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final company = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: company?.name ?? '',
                    decoration:
                        const InputDecoration(labelText: 'Company Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the company name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: company?.address ?? '',
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _address = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: company?.contact ?? '',
                    decoration: const InputDecoration(labelText: 'Contact'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the contact';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _contact = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: company?.email ?? '',
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
