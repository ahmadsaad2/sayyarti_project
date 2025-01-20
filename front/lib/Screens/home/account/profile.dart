import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sayyarti/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var logger = Logger();
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredUserName = '';
  var _enteredPhone = '';
  bool _loading = false;
  bool _isUpdating = false;
  var userId = '';
  var token = '';

  void _getUserInfo() async {
    setState(() {
      _loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    userId = prefs.getString('id')!;
    print(userId);
    print(token);
    try {
      final url = Uri.http(backendUrl, '/user/get-info/$userId');
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );
      if (res.statusCode == 200) {
        setState(() {
          _loading = false;
        });
        print(res.body);
        final data = jsonDecode(res.body);
        final dataUser = data['user'];
        _usernameController.text = dataUser['name'] ?? '';
        _phoneController.text = dataUser['phone'] ?? '';
        _emailController.text = dataUser['email'] ?? '';
        prefs.setBool('trusted', dataUser['istrusted']);
      }
    } on Exception catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  void _updateProfile() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isUpdating = true;
        });
        final url = Uri.http(backendUrl, '/user/info-update/$userId');
        final res = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'token': token,
          },
          body: json.encode({
            'email': _enteredEmail,
            'name': _enteredUserName,
            'phone': _enteredPhone,
          }),
        );
        if (res.statusCode == 200) {
          setState(() {
            _isUpdating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Name Text Field
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }

                        return null;
                      },
                      onSaved: (username) {
                        _enteredUserName = username!;
                      },
                      decoration: const InputDecoration(
                        hintText: "User Name",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Text Field
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: _phoneController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        final _phoneRegex =
                            RegExp(r'^(059|056)\d{7}$|^(59|56)\d{7}$');
                        if (!_phoneRegex.hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (phone) {
                        _enteredPhone = phone!;
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.phone_iphone_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Text Field
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      controller: _emailController,
                      cursorColor: kPrimaryColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (email) {
                        _enteredEmail = email!;
                      },
                      decoration: const InputDecoration(
                        hintText: "Your email",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.email),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Text color
                        ),
                        child: _isUpdating
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget _buildTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   TextInputType keyboardType = TextInputType.text,
  //   bool readOnly = false,
  //   bool obscureText = false,
  // }) {
  //   return TextField(
  //     controller: controller,
  //     keyboardType: keyboardType,
  //     readOnly: readOnly,
  //     obscureText: obscureText,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8.0),
  //       ),
  //       contentPadding:
  //           const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //       filled: true,
  //       fillColor: Colors.grey[200], // Background color of the text field
  //     ),
  //   );
  // }
}
