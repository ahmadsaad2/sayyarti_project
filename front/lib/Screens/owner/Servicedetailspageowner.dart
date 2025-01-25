import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? service;
  final int companyId;

  const ServiceDetailsPage({
    super.key,
    this.service,
    required this.companyId,
  });

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _timeController;
  late TextEditingController _priceController;
  late TextEditingController _detailsController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.service?['name'] ?? '');
    _timeController =
        TextEditingController(text: widget.service?['time'] ?? '');
    _priceController =
        TextEditingController(text: widget.service?['price']?.toString() ?? '');
    _detailsController =
        TextEditingController(text: widget.service?['details'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final name = _nameController.text.trim();
    final time = _timeController.text.trim();
    final price = _priceController.text.trim();
    final details = _detailsController.text.trim();

    try {
      if (widget.service == null) {
        // POST /api/services
        final url = Uri.parse('http://192.168.88.4:5000/api/services');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "company_id": widget.companyId,
            "name": name,
            "time": time,
            "price": price,
            "details": details,
          }),
        );

        if (response.statusCode == 201) {
          Navigator.pop(context, json.decode(response.body));
        } else {
          throw Exception('Failed to create service: ${response.body}');
        }
      } else {
        // PUT /api/services/:id
        final serviceId = widget.service!['id'];
        final url =
            Uri.parse('http://192.168.88.4:5000/api/services/$serviceId');
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "time": time,
            "price": price,
            "details": details,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, json.decode(response.body));
        } else {
          throw Exception('Failed to update service: ${response.body}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving service: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.service != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Service' : 'Add Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Service Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service time taken';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveService,
                      child:
                          Text(isEditMode ? 'Update Service' : 'Add Service'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
