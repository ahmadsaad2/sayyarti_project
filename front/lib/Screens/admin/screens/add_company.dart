import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() {
    return _AddCompanyScreenState();
  }
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  var _companyName = '';
  var _companyEmail = '';
  // late String _companyAddress;
  final List<String> addresses = [
    'Nablus',
    'Jenin',
    'Tubas',
    'Tulkarm',
    'Qalqilya',
    'Salfit',
    'Ramallah',
    'Al-Bireh',
    'Jericho',
    'Jerusalem',
    'Bethlehem',
    'Hebron'
  ];
  late String _companyAddress;
  var _saving = false;
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _saving = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jwtToken = prefs.getString('token');
      final url = Uri.http(backendUrl, '/admin/company/create');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'token': '$jwtToken'},
        body: json.encode({
          'email': _companyEmail,
          'name': _companyName,
          'address': _companyAddress
        }),
      );
      if (res.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('company added successfuly'),
            ),
          );
          Navigator.of(context).pop();
        }
      }

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _companyAddress = addresses[0];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add New Company',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 49, 87, 194),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/create.png',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Company Name',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the company name';
                      }
                      if (value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Name must be between 2 and 50 characters long.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _companyName = newValue!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: '',
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
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
                    onSaved: (newValue) {
                      _companyEmail = newValue!;
                    },
                  ), // email
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text(
                        'Address (Governorate)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _companyAddress,
                          items: addresses.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _companyAddress = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _saving
                        ? null
                        : () {
                            _saveForm();
                          },
                    label: _saving
                        ? const CircularProgressIndicator()
                        : const Text('Add Company'),
                    icon:_saving?null: const Icon(Icons.post_add),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
