import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final List<Map<String, dynamic>> reviews = [
    {
      "Name": "John Doe",
      "Service": "Car Wash",
      "Rating": 5,
      "Review": "Excellent service! Highly recommended.",
    },
    {
      "Name": "Jane Smith",
      "Service": "Oil Change",
      "Rating": 4,
      "Review": "Good service, but slightly delayed.",
    },
  ];

  void _deleteReview(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                reviews.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewReviewDetails(Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${review['Name']}'),
            Text('Service: ${review['Service']}'),
            Text('Rating: ${review['Rating']}'),
            const SizedBox(height: 10),
            Text('Review: ${review['Review']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: reviews.isEmpty
            ? const Center(child: Text('No reviews yet!'))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Service')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Review')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: reviews.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final review = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(review['Name'] ?? '')),
                          DataCell(Text(review['Service'] ?? '')),
                          DataCell(Text(review['Rating'].toString())),
                          DataCell(Text(
                            review['Review'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info,
                                      color: Colors.blue),
                                  onPressed: () => _viewReviewDetails(review),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteReview(index),
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
    );
  }
}
