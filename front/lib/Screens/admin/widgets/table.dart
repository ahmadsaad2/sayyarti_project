import 'package:flutter/material.dart';
import 'package:sayyarti/model/statistics.dart';

class AllDataTable extends StatelessWidget {
  final Statistics stats;

  const AllDataTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border:
              TableBorder.all(color: Colors.grey), // Add border to the table
          columnWidths: const {
            0: FlexColumnWidth(2), // First column width
            1: FlexColumnWidth(3), // Second column width
          },
          children: [
            // Users data
            _buildTableRow('User data', ''),
            _buildTableRow(
                'Total Users', '${stats.userStatistics['totalUsers']}'),
            _buildTableRow(
                'Verified Users', '${stats.userStatistics['verifiedUsers']}'),
            _buildTableRow('Unverified Users',
                '${stats.userStatistics['unverifiedUsers']}'),
            _buildTableRow(
                'Pending Users', '${stats.userStatistics['pendingUsers']}'),

            // Company data
            _buildTableRow('Company data', ''),
            _buildTableRow(
                'Total Companies', '${stats.companyStatistics['totalComp']}'),
            _buildTableRow('Yearly Subscriptions',
                '${stats.companyStatistics['yearlySub']}'),

            // Employee data
            _buildTableRow('Employee data', ''),
            _buildTableRow(
                'Total Employees', '${stats.employeeStatistics['totalEmp']}'),
            _buildTableRow('Drivers', '${stats.employeeStatistics['drivers']}'),
            _buildTableRow(
                'Mechanics', '${stats.employeeStatistics['mechanics']}'),
            _buildTableRow('Admins', '${stats.employeeStatistics['admins']}'),

            // Order data
            _buildTableRow('Order data', ''),
            _buildTableRow(
                'Total Parts', '${stats.orderStatistics['totalPart']}'),
            _buildTableRow('Total Part Revenue',
                '${stats.orderStatistics['totalPartRev']}'),
            _buildTableRow(
                'Total Services', '${stats.orderStatistics['totalService']}'),
            _buildTableRow('Total Service Revenue',
                '${stats.orderStatistics['totalServiceRev']}'),

            // Review data
            _buildTableRow('Review data', ''),
            _buildTableRow(
                'Total Reviews', '${stats.reviewStatistics['totalReviews']}'),
            _buildTableRow(
                'Average Rating', '${stats.reviewStatistics['averageRat']}'),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String header, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            header,
            style: TextStyle(
              fontWeight:
                  header.endsWith('data') ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
