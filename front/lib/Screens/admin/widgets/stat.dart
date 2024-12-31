import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Statistic extends StatelessWidget {
  const Statistic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:400,
      width: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'income',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          PieChart(
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOut,
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 30,
                  color: Colors.blue,
                  radius: 150,
                ),
                PieChartSectionData(
                  value: 60,
                  color: Colors.red,
                  radius: 150,
                ),
                PieChartSectionData(
                  value: 90,
                  color: Colors.green,
                  radius: 150,
                ),
                PieChartSectionData(
                  value: 200,
                  color: const Color.fromARGB(255, 81, 1, 83),
                  radius: 150,
                ),
                PieChartSectionData(
                  value: 250,
                  color: Colors.brown,
                  radius: 150,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
