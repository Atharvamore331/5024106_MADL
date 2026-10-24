import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
        home: const DashboardPage(),
      );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const values = [5.0, 8.0, 6.0, 9.0, 7.0];
  static const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Icon(Icons.analytics, size: 48, color: Colors.blue),
              Icon(Icons.person, size: 48, color: Colors.green),
              Icon(Icons.star, size: 48, color: Colors.orange),
              Icon(Icons.settings, size: 48, color: Colors.grey),
            ]),
            const SizedBox(height: 28),
            Text('Performance chart', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 260,
              child: BarChart(BarChartData(
                maxY: 10,
                barGroups: [
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(toY: values[i], width: 26,
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5)),
                    ]),
                ],
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return index >= 0 && index < labels.length
                          ? Padding(padding: const EdgeInsets.only(top: 8), child: Text(labels[index]))
                          : const SizedBox.shrink();
                    },
                  )),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
              )),
            ),
            const SizedBox(height: 24),
            Text('Sample network image', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network('https://picsum.photos/900/360', height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const SizedBox(height: 200,
                  child: Center(child: Text('Image unavailable. Check your connection.')))),
            ),
          ],
        ),
      );
}
