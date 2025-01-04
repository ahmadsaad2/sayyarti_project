// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
import 'package:sayyarti/Screens/map/widgets/add_location.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: LocationInput(),
      ),
    );
  }
}
