import 'package:flutter/material.dart';
import '../class/offermanager.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final offersManager = OffersManager.instance; // Access OffersManager

  final List<Map<String, String>> offers = [
    {
      "Code": "OFF10",
      "Type": "Percentage",
      "Amount": "10",
      "Minimum": "50",
      "Start": "2023-12-01",
      "End": "2023-12-31",
    },
    {
      "Code": "FLAT20",
      "Type": "Flat",
      "Amount": "20",
      "Minimum": "100",
      "Start": "2023-11-15",
      "End": "2023-11-30",
    },
  ];

  void _addOffer() async {
    final newOffer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OfferDetailsPage(offer: null),
      ),
    );

    if (newOffer != null) {
      setState(() {
        offers.add(newOffer);
      });
    }
  }

  void _editOffer(int index) async {
    final updatedOffer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailsPage(offer: offers[index]),
      ),
    );

    if (updatedOffer != null) {
      setState(() {
        offers[index] = updatedOffer;
      });
    }
  }

  void _deleteOffer(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offer'),
        content: const Text('Are you sure you want to delete this offer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                offers.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Offers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addOffer,
              child: const Text('Add Offer'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Code')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Minimum')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: offers.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final offer = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(offer['Code'] ?? '')),
                          DataCell(Text(offer['Type'] ?? '')),
                          DataCell(Text('${offer['Amount']}')),
                          DataCell(Text('${offer['Minimum']}')),
                          DataCell(Text(offer['Start'] ?? '')),
                          DataCell(Text(offer['End'] ?? '')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editOffer(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteOffer(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferDetailsPage extends StatefulWidget {
  final Map<String, String>? offer;

  const OfferDetailsPage({super.key, this.offer});

  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _typeController;
  late TextEditingController _amountController;
  late TextEditingController _minimumController;
  late TextEditingController _startController;
  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.offer?['Code'] ?? '');
    _typeController = TextEditingController(text: widget.offer?['Type'] ?? '');
    _amountController =
        TextEditingController(text: widget.offer?['Amount'] ?? '');
    _minimumController =
        TextEditingController(text: widget.offer?['Minimum'] ?? '');
    _startController =
        TextEditingController(text: widget.offer?['Start'] ?? '');
    _endController = TextEditingController(text: widget.offer?['End'] ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _typeController.dispose();
    _amountController.dispose();
    _minimumController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _saveOffer() {
    if (_formKey.currentState!.validate()) {
      final newOffer = {
        'Code': _codeController.text.trim(),
        'Type': _typeController.text.trim(),
        'Amount': _amountController.text.trim(),
        'Minimum': _minimumController.text.trim(),
        'Start': _startController.text.trim(),
        'End': _endController.text.trim(),
      };
      Navigator.pop(context, newOffer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.offer == null ? 'Add Offer' : 'Edit Offer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Offer Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter offer code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter type (e.g., Percentage or Flat)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _minimumController,
                decoration: const InputDecoration(labelText: 'Minimum Spend'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter minimum spend';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _startController,
                decoration: const InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _endController,
                decoration: const InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOffer,
                child: const Text('Save Offer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
