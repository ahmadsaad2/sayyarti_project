import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/admin/screens/admin_home.dart';
import 'package:sayyarti/Screens/owner/owner.dart';
import '../../home/home.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/forgot_passwod.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  int loggedInUserId = 0; // Initialize with a default value
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPass = '';
  var _isLogging = false;
  void onLoginSuccess(int userId) {
    setState(() {
      loggedInUserId = userId; // Assign the logged-in user's ID
    });
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLogging = true;
      });

      final url = Uri.http(backendUrl, '/auth/signin');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': _enteredEmail,
          'password': _enteredPass,
        }),
      );

      setState(() {
        _isLogging = false;
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final prefs = await SharedPreferences.getInstance();

        // Save token and role in shared preferences
        prefs.setString('token', data['token']);
        prefs.setString('role', data['role']);
        prefs.setString('name', data['username']);
        prefs.setInt('userId', data['id']); // Save userId as an integer
        prefs.setBool('trusted', data['istrusted']);

        final String? phone = data['phone'];
        if (phone != null && phone.isNotEmpty) {
          prefs.setString('phone', phone);
        } else {
          prefs.remove('phone');
        }

        if (data['role'] == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (data['role'] == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminHome()),
          );
        } else if (data['role'] == 'company_admin') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceCenterHomePage(userId: data['id']),
            ),
          );
        } else if (data['role'] == 'service_provider') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Text('service_provider'),
            ),
          );
        }
      } else if (res.statusCode >= 400) {
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';
              }
              final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 8) {
                  return 'Password must be at least 8 characters long.';
                }
                return null;
              },
              onSaved: (pass) {
                _enteredPass = pass!;
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              _saveForm();
            },
            child: _isLogging
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    "Login".toUpperCase(),
                  ),
          ),
          const SizedBox(height: 10),
          const ForgotPassword(),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
