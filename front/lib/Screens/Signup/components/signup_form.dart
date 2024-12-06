// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Variable to store the selected user type
  String _userType = 'client'; // Default user type is 'client'

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Email TextField
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          // Password TextField
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
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
            ),
          ),
          // Dropdown for User Type selection
          const SizedBox(height: defaultPadding / 2),
          DropdownButtonFormField<String>(
            value: _userType,
            items: const [
              DropdownMenuItem<String>(
                value: 'client',
                child: Text('Client'),
              ),
              DropdownMenuItem<String>(
                value: 'garage',
                child: Text('Garage Owner'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _userType = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select User Type',
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.account_circle),
              ),
            ),
          ),
          // Padding after the dropdown to separate it from the next button
          const SizedBox(height: defaultPadding), // This is the added padding

          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              // Here you can handle the sign-up process, including saving the userType to the database
              print('User Type: $_userType');
              // Call your sign-up method with the email, password, and userType
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
