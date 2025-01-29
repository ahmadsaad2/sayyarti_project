import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/home/account/addcar.dart';
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/addcar.dart';
import 'package:http/http.dart' as http;

class MyCarsPage extends StatefulWidget {
  MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  final List<Map<String, String>> cars = [];
  var _isLoading = false;
  void _fetch() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.http(backendUrl, '/user/mycars/${prefs.getInt('userId')}');
    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': prefs.getString('token')!,
      },
    );
    if (res.statusCode == 200) {
      List<dynamic> jsonRes = jsonDecode(res.body);
      print(jsonRes);
      for (var car in jsonRes) {
        cars.add({
          'id': car['id'].toString(),
          'user_id': car['user_id'].toString(),
          'title': car['brand'],
          'subtitle': car['model'],
          'model': car['year'].toString(),
          'wheel': car['wheel'].toString(),
          'fuel': car['fuel'],
        });
      }
    } else {
      print('failed to fetch ${res.statusCode}');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddCar(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // List of cars
                  Expanded(
                    child: ListView.builder(
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        // Access each car's details dynamically
                        final car = cars[index];
                        return ListTile(
                          title: Text(car['title'] ?? 'No Title'),
                          subtitle: Text(car['subtitle'] ?? 'No Subtitle'),
                          leading: const Icon(
                              Icons.car_rental_sharp), // Change to home icon
                          trailing: Text(car['model'] ?? 'No Model'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add Car Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the Add Car Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddCarPage()),
                        );
                      },
                      child: const Text('Add Car'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
