import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/home/accountverifiaction/widget/picker_widget.dart';

class Verify extends StatelessWidget {
  const Verify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Account'),
        backgroundColor: const Color.fromARGB(255, 16, 80, 177),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImagePick(),
          ],
        ),
      ),
    );
  }
}
