import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  final List<Map<String, String>> _services = [
    {
      "Name": "Oil Change",
      "Time": "30 mins",
      "Price": "50",
      "Details": "Change engine oil and filter"
    },
    {
      "Name": "Tire Replacement",
      "Time": "1 hour",
      "Price": "100",
      "Details": "Replace all four tires"
    },
  ];

  List<Map<String, String>> get services => _services;

  void updateService(int index, Map<String, String> updatedService) {
    _services[index] = updatedService;
    notifyListeners();
  }
}
