import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionFollowUpScreen extends StatelessWidget {
  final List<double> muacData = [115, 118, 120, 125];

  NutritionFollowUpScreen({super.key}); // Exemple de données

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi Nutritionnel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: const FlTitlesData(
              // leftTitles: SideTitles(showTitles: true),
              // bottomTitles: SideTitles(showTitles: true),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: muacData
                    .asMap()
                    .entries
                    .map((entry) =>
                        FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
                color: Colors.blue,
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
