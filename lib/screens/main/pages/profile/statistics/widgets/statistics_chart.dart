import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';

class StatisticsChart extends StatelessWidget {
  final List<UserTargetCalculation> data;
  final double latestWeight;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const StatisticsChart({
    super.key,
    required this.data,
    required this.latestWeight,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Column(
        children: [
          Icon(Icons.show_chart, size: 64, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'No data for chart this year.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      );
    }

    final sortedData = [...data]
      ..sort((a, b) => a.calculatedTargetDate.compareTo(b.calculatedTargetDate));

    final spots = sortedData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.calculatedWeight);
    }).toList();

    final double minY = sortedData
        .map((e) => e.calculatedWeight)
        .reduce((a, b) => a < b ? a : b) -
        1.0;
    final double maxY = sortedData
        .map((e) => e.calculatedWeight)
        .reduce((a, b) => a > b ? a : b) +
        1.0;

    return Column(
      children: [
        Text(
          "You're on track to reach ${latestWeight.toStringAsFixed(1)} kg",
          style: textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          width: sortedData.length * 70,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
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
                          style: TextStyle(fontSize: 10, color: colorScheme.onSurface),
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
                      if (index < sortedData.length) {
                        final date = sortedData[index].calculatedTargetDate;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${date.month}/${date.day}',
                            style: TextStyle(fontSize: 10, color: colorScheme.onSurface),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
    );
  }
}
