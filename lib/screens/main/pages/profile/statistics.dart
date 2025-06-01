import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightEntry {
  final String date;
  final double weight;
  const WeightEntry(this.date, this.weight);
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final List<WeightEntry> weightData = const [
    WeightEntry('Now', 50),
    WeightEntry('06/09', 49.6),
    WeightEntry('06/24', 48.8),
    WeightEntry('07/14', 48),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);
    final hasData = weightData.isNotEmpty;

    final spots = weightData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: textTheme.titleMedium,),
      ),
      body: hasData
          ? ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        "You're on track to reach 48kg by July 14",
                        style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 220,
                        width: weightData.length * 70,
                        child: LineChart(
                          LineChartData(
                            minY: 47,
                            maxY: 51,
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    return LineTooltipItem(
                                      '${spot.y.toStringAsFixed(1)} kg',
                                      textTheme.bodySmall!.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, _) {
                                    if (value % 1 == 0) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colorScheme.onSurface,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, _) {
                                    final index = value.toInt();
                                    if (index < weightData.length) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(top: 8),
                                        child: Text(
                                          weightData[index].date,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                  sideTitles:
                                  SideTitles(showTitles: false)
                              ),
                              topTitles: AxisTitles(
                                  sideTitles:
                                  SideTitles(showTitles: false)
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                barWidth: 3,
                                color: colorScheme.primary,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary.withAlpha(100),
                                      colorScheme.primary.withAlpha(20),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart,
                size: 64, color: colorScheme.primary
            ),
            const SizedBox(height: 16),
            Text(
              'Your progress and statistics will be displayed here.',
              style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey
              )
            ),
          ],
        ),
      ),
    );
  }
}
