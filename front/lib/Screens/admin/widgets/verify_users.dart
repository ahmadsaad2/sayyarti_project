import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyUsers extends StatefulWidget {
  const VerifyUsers({
    super.key,
    required this.userID,
    required this.userName,
    required this.imageUrl,
    required this.userPhone,
  });
  final int userID;
  final String userName;
  final String imageUrl;
  final String userPhone;
  @override
  State<VerifyUsers> createState() {
    return _VerifyUsersState();
  }
}

class _VerifyUsersState extends State<VerifyUsers> {
  void _accept() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.http(backendUrl, '/user/info-update/${widget.userID}');
    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': prefs.getString('token')!,
      },
      body: json.encode(
        {
          'trusted': true,
          'verify_stat': 'verified',
        },
      ),
    );
    if (res.statusCode != 200) {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('field to verify user please try again later'),
          backgroundColor: Colors.red,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  void _decline() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.http(backendUrl, '/user/info-update//${widget.userID}');
    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'token': prefs.getString('token')!,
      },
      body: json.encode(
        {
          'trusted': false,
          'verify_stat': 'unverified',
        },
      ),
    );
    if (res.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('field please try again later'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify this user'),
        backgroundColor: const Color.fromARGB(255, 49, 87, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Username: ${widget.userName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${widget.userPhone}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.network(
                widget.imageUrl,
                width: 400,
                height: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 200, color: Colors.red);
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: _accept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _decline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Verify this user',
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black,
  //         ),
  //       ),
  //       backgroundColor: const Color.fromARGB(255, 49, 87, 194),
  //       centerTitle: true,
  //     ),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.all(15),
  //         child: ConstrainedBox(
  //           constraints: BoxConstraints(
  //             minHeight: MediaQuery.of(context).size.height,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   const Text('Username:'),
  //                   Text(
  //                     widget.userName,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   const Text('Phone #:'),
  //                   Text(
  //                     widget.userPhone,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                 width: 600,
  //                 height: 800,
  //                 child: Image.network(
  //                   widget.imageUrl,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton.icon(
  //                     onPressed: () {
  //                       _accept();
  //                     },
  //                     label: const Text('Verify'),
  //                     icon: Icon(Icons.thumb_up_alt_sharp),
  //                   ),
  //                   ElevatedButton.icon(
  //                     onPressed: () {
  //                       _decline();
  //                     },
  //                     label: const Text('Decline'),
  //                     icon: Icon(Icons.thumb_down_alt_sharp),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
