import 'package:flutter/material.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  FAQsPageState createState() => FAQsPageState();
}

class FAQsPageState extends State<FAQsPage> {
  final List<Map<String, String>> faqs = [
    {
      "Title": "How much do you charge?",
      "Description": "Our charges depend on the service required."
    },
    {
      "Title": "How long will it take?",
      "Description": "The time depends on the service complexity."
    },
    {
      "Title": "What is the refund policy?",
      "Description": "Refunds are processed within 5-7 business days."
    },
    {
      "Title": "Do you collect the car?",
      "Description": "Yes, we offer a car collection service."
    },
  ];

  void _addFAQ() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQForm(
          title: null,
          description: null,
          onSave: (title, description) {
            setState(() {
              faqs.add({"Title": title, "Description": description});
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _editFAQ(int index) async {
    final updatedFAQ = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQForm(
          title: faqs[index]['Title'],
          description: faqs[index]['Description'],
          onSave: (title, description) {
            setState(() {
              faqs[index] = {"Title": title, "Description": description};
            });
            Navigator.pop(context);
          },
        ),
      ),
    );

    if (updatedFAQ != null) {
      setState(() {
        faqs[index] = updatedFAQ;
      });
    }
  }

  void _deleteFAQ(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete FAQ'),
        content: const Text('Are you sure you want to delete this FAQ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                faqs.removeAt(index);
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
        title: const Text('Manage FAQs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addFAQ,
              child: const Text('Add FAQ'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: faqs.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final faq = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(faq['Title'] ?? '')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editFAQ(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteFAQ(index),
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

class FAQForm extends StatefulWidget {
  final String? title;
  final String? description;
  final void Function(String title, String description) onSave;

  const FAQForm({
    super.key,
    required this.title,
    required this.description,
    required this.onSave,
  });

  @override
  FAQFormState createState() => FAQFormState();
}

class FAQFormState extends State<FAQForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveFAQ() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title == null ? 'Add FAQ' : 'Edit FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'FAQ Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter FAQ name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFAQ,
                child: const Text('Save FAQ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
