import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sayyarti/constants.dart';
import './Servicedetailspageowner.dart';

class ServicesPage extends StatefulWidget {
  final int companyId;
  const ServicesPage({super.key, required this.companyId});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<Map<String, dynamic>> services = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() => _isLoading = true);

    try {
      // Example: GET /api/services?company_id=widget.companyId
      final url = Uri.http(
        backendUrl,
        '/api/services/all/${widget.companyId}',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          services = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching services: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addService() async {
    final newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(
          service: null,
          companyId: widget.companyId,
        ),
      ),
    );

    // If a service was successfully added (non-null result), re-fetch
    if (newService != null) {
      _fetchServices();
    }
  }

  Future<void> _editService(int index) async {
    final serviceToEdit = services[index];
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(
          service: serviceToEdit,
          companyId: widget.companyId,
        ),
      ),
    );

    // If a service was successfully updated, re-fetch
    if (updated != null) {
      _fetchServices();
    }
  }

  Future<void> _deleteService(int index) async {
    final serviceToDelete = services[index];
    final serviceId = serviceToDelete['id'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = Uri.http(backendUrl, '/api/services/$serviceId');
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          setState(() {
            services.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service deleted!')),
          );
        } else {
          throw Exception('Failed to delete service');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting service: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Offered'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                        rows: services.asMap().entries.map((entry) {
                          final index = entry.key;
                          final service = entry.value;

                          return DataRow(
                            cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(service['name'] ?? '')),
                              DataCell(Text(service['time'] ?? '')),
                              DataCell(Text('\$${service['price'] ?? '0'}')),
                              DataCell(Text(service['details'] ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _editService(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteService(index),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
