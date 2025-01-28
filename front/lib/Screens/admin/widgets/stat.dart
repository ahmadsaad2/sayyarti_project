import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sayyarti/model/statistics.dart';

class Statistic extends StatelessWidget {
  const Statistic({super.key, required this.stats});

  final Statistics stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Text('Virification Chart',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(getUserPieChartData(stats)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Column(children: [
                Text('Employees',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 1.56,
                  child: BarChart(getEmployeeBarChartData(stats)),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  Text(
                    'Revenue From Companies',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: LineChart(getCompanyLineChartData(stats)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Orders Statistics',
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text('Total Parts: ${stats.orderStatistics['totalPart']}'),
            //     Text(
            //         'Total Part Revenue: ${stats.orderStatistics['totalPartRev']}'),
            //     Text(
            //         'Total Services: ${stats.orderStatistics['totalService']}'),
            //     Text(
            //         'Total Service Revenue: ${stats.orderStatistics['totalServiceRev']}'),
            //   ],
            // ),
            // const SizedBox(height: 12),
            // Text(
            //   'Review Statistics',
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //         'Total Reviews: ${stats.reviewStatistics['totalReviews']}'),
            //     Text('Average Rating: ${stats.reviewStatistics['averageRat']}'),
            //   ],
            // ),
            Card(
              child: Column(
                children: [
                  Text(
                    'Orders Statistics',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(
                        color: Colors.grey), // Add border to the table
                    columnWidths: const {
                      0: FlexColumnWidth(2), // First column width
                      1: FlexColumnWidth(3), // Second column width
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Parts',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text('${stats.orderStatistics['totalPart']}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Part Revenue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${stats.orderStatistics['totalPartRev']}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Services',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${stats.orderStatistics['totalService']}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Service Revenue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${stats.orderStatistics['totalServiceRev']}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Text(
                    'Review Statistics',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(
                        color: Colors.grey), // Add border to the table
                    columnWidths: const {
                      0: FlexColumnWidth(2), // First column width
                      1: FlexColumnWidth(3), // Second column width
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total Reviews',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${stats.reviewStatistics['totalReviews']}'),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Average Rating',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text('${stats.reviewStatistics['averageRat']}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
