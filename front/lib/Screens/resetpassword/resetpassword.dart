import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/resetpassword/enter_new_pass.dart';
import '../../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  final String title;

  const ResetPasswordPage({Key? key, required this.title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _loading = false;

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });

      final url = Uri.http(backendUrl, '/auth/reset');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _enteredEmail,
        }),
      );
      setState(() {
        _loading = false;
      });
      if (res.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => EnterNewPass(email: _enteredEmail),
          ),
        );
      }

      if (res.statusCode >= 400) {
        if (!context.mounted) {
          print('no context mounted');
          return;
        }
        final Map<String, dynamic> err = json.decode(res.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(err['message'].toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Reset Your Password",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter the email address associated with your account.",
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredEmail = newValue!;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _saveForm();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 18,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Reset Password",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
