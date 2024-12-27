// this page for grage service
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, String>> services = [
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

  void _addService() async {
    final newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServiceDetailsPage(service: null),
      ),
    );

    if (newService != null) {
      setState(() {
        services.add(newService);
      });
    }
  }

  void _editService(int index) async {
    final updatedService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(service: services[index]),
      ),
    );

    if (updatedService != null) {
      setState(() {
        services[index] = updatedService;
      });
    }
  }

  void _deleteService(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                services.removeAt(index);
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
        title: const Text('Services Offered'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addService,
              child: const Text('Add Service'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Details')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: services.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final service = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(service['Name'] ?? '')),
                          DataCell(Text(service['Time'] ?? '')),
                          DataCell(Text('\$${service['Price']}')),
                          DataCell(Text(service['Details'] ?? '')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editService(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteService(index),
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

class ServiceDetailsPage extends StatefulWidget {
  final Map<String, String>? service;

  const ServiceDetailsPage({super.key, this.service});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _timeController;
  late TextEditingController _priceController;
  late TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.service?['Name'] ?? '');
    _timeController =
        TextEditingController(text: widget.service?['Time'] ?? '');
    _priceController =
        TextEditingController(text: widget.service?['Price'] ?? '');
    _detailsController =
        TextEditingController(text: widget.service?['Details'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final newService = {
        'Name': _nameController.text.trim(),
        'Time': _timeController.text.trim(),
        'Price': _priceController.text.trim(),
        'Details': _detailsController.text.trim(),
      };
      Navigator.pop(context, newService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                    return 'Please enter service time';
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
              ElevatedButton(
                onPressed: _saveService,
                child: const Text('Save Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
