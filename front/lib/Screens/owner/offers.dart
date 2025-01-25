import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'offer_details.dart';

class OffersPage extends StatefulWidget {
  final int companyId; // pass the company ID from the drawer or wherever
  const OffersPage({Key? key, required this.companyId}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<Map<String, dynamic>> offers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(
        'http://192.168.88.4:5000/api/offers?company_id=${widget.companyId}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          offers = data.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load offers');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching offers: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addOffer() async {
    final newOffer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailsPage(
          offer: null,
          companyId: widget.companyId,
        ),
      ),
    );
    if (newOffer != null) {
      _fetchOffers(); // Refresh after adding
    }
  }

  Future<void> _editOffer(int index) async {
    final offerToEdit = offers[index];
    final updatedOffer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailsPage(
          offer: offerToEdit,
          companyId: widget.companyId,
        ),
      ),
    );
    if (updatedOffer != null) {
      _fetchOffers(); // Refresh after editing
    }
  }

  Future<void> _deleteOffer(int index) async {
    final offerToDelete = offers[index];
    final offerId = offerToDelete['id'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offer'),
        content: const Text('Are you sure you want to delete this offer?'),
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
        final url =
            Uri.parse('http://192.168.88.4:5000/api/api/offers/$offerId');
        final response = await http.delete(url);
        if (response.statusCode == 200) {
          setState(() {
            offers.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Offer deleted!')),
          );
        } else {
          throw Exception('Failed to delete offer');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting offer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Offers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Minimum')),
                          DataColumn(label: Text('Start Date')),
                          DataColumn(label: Text('End Date')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: offers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final offer = entry.value;

                          return DataRow(
                            cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(offer['description'] ?? '')),
                              DataCell(Text(offer['type'] ?? '')),
                              DataCell(Text('${offer['amount'] ?? ''}')),
                              DataCell(Text('${offer['minimum_spend'] ?? ''}')),
                              DataCell(Text(offer['start_date'] ?? '')),
                              DataCell(Text(offer['end_date'] ?? '')),
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
