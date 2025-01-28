import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/Screens/admin/widgets/verify_users.dart';
import 'package:sayyarti/constants.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _VerificationScreenState();
  }
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<String> imageUrls = [];
  List<int> usersId = [];
  List<String> usernames = [];
  List<String> phoneNumbers = [];
  var _isLoading = false;

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.http(backendUrl, '/admin/unverified-users');
    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(res.body);
      final List<dynamic> data = responseData['unverifiedUsers'];
      imageUrls.clear();
      usersId.clear();
      usernames.clear();
      phoneNumbers.clear();
      print('here');
      print(data);

      for (var user in data) {
        usersId.add(user['id']);
        imageUrls.add(user['img_uri']);
        usernames.add(user['name']);
        phoneNumbers.add(user['phone']);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending verification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationScreen(),
                  ),
                );
              },
              icon: Icon(Icons.refresh))
        ],
        backgroundColor: const Color.fromARGB(255, 49, 87, 194),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VerifyUsers(
                                userID: usersId[index],
                                userName: usernames[index],
                                imageUrl: imageUrls[index],
                                userPhone: phoneNumbers[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
