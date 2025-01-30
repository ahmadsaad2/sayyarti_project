import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sayyarti/constants.dart'; // For date formatting

class OfferDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? offer;
  final int companyId;

  const OfferDetailsPage({
    super.key,
    this.offer,
    required this.companyId,
  });

  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descController;
  late TextEditingController _amountController;
  late TextEditingController _minController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  String _selectedType = 'Percentage'; // Default offer type
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descController =
        TextEditingController(text: widget.offer?['description'] ?? '');
    _amountController =
        TextEditingController(text: widget.offer?['amount']?.toString() ?? '');
    _minController = TextEditingController(
        text: widget.offer?['minimum_spend']?.toString() ?? '');
    _startController =
        TextEditingController(text: widget.offer?['start_date'] ?? '');
    _endController =
        TextEditingController(text: widget.offer?['end_date'] ?? '');

    // Set initial offer type if editing
    if (widget.offer != null) {
      _selectedType = widget.offer!['type'] ?? 'Percentage';
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _minController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _saveOffer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final description = _descController.text.trim();
    final amount = _amountController.text.trim();
    final minSpend = _minController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();

    try {
      if (widget.offer == null) {
        // POST
        final url = Uri.http(backendUrl, '/api/offers');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'company_id': widget.companyId,
            'description': description,
            'type': _selectedType,
            'amount': amount,
            'minimum_spend': minSpend,
            'start_date': start,
            'end_date': end,
          }),
        );

        if (response.statusCode == 201) {
          Navigator.pop(context, jsonDecode(response.body));
        } else {
          throw Exception('Failed to create offer: ${response.body}');
        }
      } else {
        // PUT
        final offerId = widget.offer!['id'];
        final url = Uri.http(backendUrl, '/api/offers/$offerId');
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'description': description,
            'type': _selectedType,
            'amount': amount,
            'minimum_spend': minSpend,
            'start_date': start,
            'end_date': end,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, jsonDecode(response.body));
        } else {
          throw Exception('Failed to update offer: ${response.body}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving offer: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (isStartDate) {
        _startController.text = formattedDate;
      } else {
        _endController.text = formattedDate;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.offer != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Offer' : 'Add Offer',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 12, 107),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter offer description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Percentage', 'Flat']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Select offer type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Spend',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter minimum spend';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ),
                readOnly: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Select start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ),
                readOnly: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Select end date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 7, 160),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      //TODO fire base add to send notification
                      child: Text(
                        isEditing ? 'Update Offer' : 'Add Offer',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
