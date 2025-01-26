import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:sayyarti/Screens/home/offercard.dart';
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() {
    return _AddCarState();
  }
}

class _AddCarState extends State<AddCar> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrand;
  String? _selectedModel;
  String? _fuelType;
  int? _yearOfManufacture;
  int? _wheelSize;
  var _saving = false;
  final List<Map<String, List<String>>> cars = [];
  final List<String> brandNames = [];
  final List<String> fuelTypes = ["Petrol 95", "Diesel", "Petrol 98"];

  void _getCarData() async {
    final url = Uri.http(backendUrl, '/user/get-brands/');
    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Map<String, dynamic> data = jsonDecode(res.body);
    List<dynamic> brands = data['brand'];
    for (var brand in brands) {
      cars.add({brand['brand']: List<String>.from(brand['models'])});
      brandNames.add(brand['brand']);
    }
    _selectedBrand = brandNames.isNotEmpty ? brandNames[0] : null;
    setState(() {});
    print(cars);
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _saving = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jwtToken = prefs.getString('token');
      String? userId = prefs.getString('id');
      final url = Uri.http(backendUrl, '/user/add-car/$userId');
      print(userId);
      print('sending the request');
      print(url);
      print('Request Body: ${json.encode({
            'brand': _selectedBrand,
            'model': _selectedModel,
            'year': _yearOfManufacture,
            'wheel': _wheelSize,
            'fuel': _fuelType,
          })}');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': jwtToken!,
        },
        body: json.encode({
          'brand': _selectedBrand,
          'model': _selectedModel,
          'year': _yearOfManufacture,
          'wheel': _wheelSize,
          'fuel': _fuelType,
        }),
      );
      print('response recieved');
      setState(() {
        _saving = false;
      });
      if (res.statusCode == 201) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add car'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _getCarData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> models = [];
    if (_selectedBrand != null) {
      for (var car in cars) {
        if (car.containsKey(_selectedBrand)) {
          models = car[_selectedBrand]!;
          break;
        }
      }
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Add Car'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedBrand,
                  decoration: const InputDecoration(
                    label: Text(
                      'Brand',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  items: brandNames.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _selectedBrand = val;
                      _selectedModel = null;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select Your Car Brand';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedModel,
                  decoration: const InputDecoration(
                    label: Text(
                      'Model',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  items: models.map((model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _selectedModel = val;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select Your Car Model';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    label: Text(
                      'Fuel type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  items: fuelTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _fuelType = val;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a fuel type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'e.g. 2022',
                    label: Text(
                      'Year of Manufacture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the year of manufacture';
                    }
                    final int? year = int.tryParse(value);
                    if (year == null) {
                      return 'Please enter a valid year';
                    }
                    final int currentYear = DateTime.now().year;
                    if (year < 1900 || year > currentYear) {
                      return 'Please enter a year between 1900 and $currentYear';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _yearOfManufacture = int.tryParse(newValue!);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'e.g. 16',
                    counterText: 'inch',
                    label: Text(
                      'Wheel size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the wheel size';
                    }
                    final int? wheelSize = int.tryParse(value);
                    if (wheelSize == null) {
                      return 'Please enter a valid whole number';
                    }
                    if (wheelSize < 10 || wheelSize > 30) {
                      return 'Please enter a wheel size between 10 and 30 inches';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _wheelSize = int.tryParse(newValue!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveForm();
                  },
                  child: _saving
                      ? const CircularProgressIndicator()
                      : const Text('Add my car'),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
