import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sayyarti/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Statistics {
  final Map<String, dynamic> userStatistics;
  final Map<String, dynamic> companyStatistics;
  final Map<String, dynamic> employeeStatistics;
  final Map<String, dynamic> orderStatistics;
  final Map<String, dynamic> reviewStatistics;

  Statistics({
    required this.userStatistics,
    required this.companyStatistics,
    required this.employeeStatistics,
    required this.orderStatistics,
    required this.reviewStatistics,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      userStatistics: json['userStatistics'],
      companyStatistics: json['companyStatistics'],
      employeeStatistics: json['employeeStatistics'],
      orderStatistics: json['orderStatistics'],
      reviewStatistics: json['reviewStatistics'],
    );
  }
}

PieChartData getUserPieChartData(Statistics stats) {
  return PieChartData(
    sections: [
      PieChartSectionData(
        value: stats.userStatistics['verifiedUsers'].toDouble(),
        color: Colors.green,
        title: 'Verified',
      ),
      PieChartSectionData(
        value: stats.userStatistics['unverifiedUsers'].toDouble(),
        color: Colors.red,
        title: 'Unverified',
      ),
      PieChartSectionData(
        value: stats.userStatistics['pendingUsers'].toDouble(),
        color: Colors.orange,
        title: 'Pending',
      ),
    ],
  );
}

BarChartData getEmployeeBarChartData(Statistics stats) {
  return BarChartData(
    barGroups: [
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
              toY: stats.employeeStatistics['totalEmp'].toDouble(),
              color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
              toY: stats.employeeStatistics['drivers'].toDouble(),
              color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
              toY: stats.employeeStatistics['mechanics'].toDouble(),
              color: Colors.green),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
              toY: stats.employeeStatistics['admins'].toDouble(),
              color: Colors.red),
        ],
      ),
    ],
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            switch (value.toInt()) {
              case 0:
                return const Text('Drivers');
              case 1:
                return const Text('Mechanics');
              case 2:
                return const Text('Admins');
              case 3:
                return const Text('ALL');
              default:
                return const Text('');
            }
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(value.toInt().toString());
          },
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(show: false),
    gridData: FlGridData(show: false),
  );
}

// BarChartData getCompanyBarChartData(Statistics stats) {
//   return BarChartData(
//     barGroups: [
//       BarChartGroupData(
//         x: 0,
//         barRods: [
//           BarChartRodData(
//               toY: stats.companyStatistics['totalComp'].toDouble(),
//               color: Colors.blue),
//         ],
//       ),
//       BarChartGroupData(
//         x: 1,
//         barRods: [
//           BarChartRodData(
//               toY: stats.companyStatistics['yearlySub'].toDouble(),
//               color: Colors.green),
//         ],
//       ),
//     ],
//   );
// }
BarChartData getCompanyBarChartData(Statistics stats) {
  return BarChartData(
    barGroups: [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: stats.companyStatistics['totalComp'].toDouble(),
            color: Colors.blue,
            width: 15, // Adjust bar width
          ),
          BarChartRodData(
            toY: stats.companyStatistics['yearlySub'].toDouble(),
            color: Colors.green,
            width: 15, // Adjust bar width
          ),
        ],
      ),
    ],
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return const Text('Companies');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
                value.toInt().toString()); // Left axis for total companies
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(value
                .toInt()
                .toString()); // Right axis for yearly subscriptions
          },
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(show: false),
    gridData: FlGridData(show: false),
  );
}

LineChartData getCompanyLineChartData(Statistics stats) {
  return LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(
              0,
              stats.companyStatistics['totalComp']
                  .toDouble()), // Total Companies
          FlSpot(
              1,
              stats.companyStatistics['yearlySub']
                  .toDouble()), // Yearly Subscriptions
        ],
        isCurved: true, // Set to true for a curved line
        color: Colors.blue, // Line color
        barWidth: 4, // Line thickness
        belowBarData: BarAreaData(show: true), // Hide area below the line
        dotData: FlDotData(show: true), // Show data points
      ),
    ],
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text('Total Companies',
                      style: TextStyle(fontSize: 12));
                case 1:
                  return const Text('Yearly Subs',
                      style: TextStyle(fontSize: 12));
                default:
                  return const Text('');
              }
            },
            reservedSize: 0),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(value.toInt().toString()); // Left axis for values
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Hide right-side titles
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false), // Hide top titles
      ),
    ),
    borderData: FlBorderData(show: false), // Hide chart border
    gridData: FlGridData(show: true), // Hide grid lines
    minX: 0, // Set minimum x-axis value
    maxX: 1, // Set maximum x-axis value
    minY: 0, // Set minimum y-axis value
    maxY: stats.companyStatistics['yearlySub'].toDouble(),
  );
}

Future<Map<String, dynamic>> fetchStatistics() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = Uri.http(backendUrl, '/admin/stat/');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'token': token!,
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load Statistics');
  }
}
