import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/admin/widgets/parts.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: AddProduct());
  }
}
