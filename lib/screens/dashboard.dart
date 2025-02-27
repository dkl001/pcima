import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de Bord')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: const FlTitlesData(
              // leftTitles: SideTitles(showTitles: true),
              // bottomTitles: SideTitles(showTitles: true),
            ),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(toY: 30, color: Colors.blue),
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(toY: 20, color:   Colors.red),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
