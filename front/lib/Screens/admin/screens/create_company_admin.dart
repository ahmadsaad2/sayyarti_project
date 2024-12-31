import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCompanyAdminScreen extends StatefulWidget {
  const CreateCompanyAdminScreen({super.key});

  @override
  State<CreateCompanyAdminScreen> createState() {
    return _CreateCompanyAdminScreenState();
  }
}

class _CreateCompanyAdminScreenState extends State<CreateCompanyAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  var _adminEmail = '';
  var _enteredPass = '';
  var _companyName = '';
  var _username='';
  var _saving = false;

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _saving = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jwtToken = prefs.getString('token');
      final url = Uri.http(backendUrl, '/admin/company-admin/create');
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'token': '$jwtToken'},
        body: json.encode({
          'name': _username,
          'email': _adminEmail,
          'password': _enteredPass,
          'company': _companyName,
        }),
      );
      if (res.statusCode == 201) {
        setState(() {
          _saving = false;
        });
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent.shade400,
                      size: 50,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Company Admin created successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else{
        setState(() {
          _saving = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                'Failed to create company admin. Please check your internet or if Admin already exists ',
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                )
              ],
            );
          },
        );
      }

      return;
    }
  }

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
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/company_admin.png',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  DropdownSearch<String>(
                    items: (filter, loadProps) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? jwtToken = prefs.getString('token');

                      final url = Uri.http(backendUrl, '/admin/company');
                      final response = await http.get(
                        url,
                        headers: {
                          'Content-Type': 'application/json',
                          'token': '$jwtToken',
                        },
                      );

                      if (response.statusCode == 200) {
                        final Map<String, dynamic> jsonData =
                            jsonDecode(response.body);
                        return (jsonData['companiesNames'] as List)
                            .map((company) => company['name'] as String)
                            .toList();
                      } else {
                        // Return an empty list if the request fails
                        return [];
                      }
                    },
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                    ),
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                          labelText: 'Select a Company',
                          hintText: 'Search for a Company',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide:
                                  const BorderSide(color: Colors.green))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a company';
                      }
                      return null;
                    },
                    onSaved:(value) {
                      _companyName = value!;
                    } ,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.person),
                      ),
                      labelText: 'Admin User Name',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 6) {
                        return 'Please enter a user name longer that 6 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue){
                      _username = newValue!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.email),
                      ),
                      labelText: 'Admin Email',
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
                      _adminEmail = newValue!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 8) {
                        return 'Password must be atleast 8 characters long.';
                      }
                      return null;
                    },
                    onSaved: (pass) {
                      _enteredPass = pass!;
                    },
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: "Admin password",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.lock),
                      ),
                    ),
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
                        : const Text('Create Company Admin'),
                    icon: _saving
                        ? null
                        : const Icon(Icons.assignment_ind_outlined),
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
