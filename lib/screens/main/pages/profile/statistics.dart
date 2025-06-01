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

  final double currentCalories = 1200;
  final double dailyTargetCalories = 1800;

  final List<Map<String, dynamic>> history = const [
    {'date': '2024-06-01', 'weight': 50.0, 'calories': 2450},
    {'date': '2024-06-09', 'weight': 49.6, 'calories': 2300},
    {'date': '2024-06-24', 'weight': 48.8, 'calories': 2200},
    {'date': '2024-07-14', 'weight': 48.0, 'calories': 2150},
  ];

  bool _historyExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasData = weightData.isNotEmpty;

    final spots = weightData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: textTheme.titleMedium),
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
                        style: textTheme.titleSmall,
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
                                        color: colorScheme
                                            .onPrimaryContainer,
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
                                          color:
                                          colorScheme.onSurface,
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
                  ),
                ),
                const SizedBox(height: 28),
                Text("Today's Calories", style: textTheme.titleSmall),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: currentCalories / dailyTargetCalories,
                  backgroundColor: colorScheme.primary.withAlpha(40),
                  color: colorScheme.primary,
                  minHeight: 14,
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentCalories.toInt()} / ${dailyTargetCalories.toInt()} kcal',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          StatefulBuilder(
            builder: (context, setInnerState) {
              return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                ),
                elevation: 2,
                color: colorScheme.surface,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setInnerState(() {
                          _historyExpanded = !_historyExpanded;
                        });
                      },
                      child: Container(
                        color: colorScheme.primary.withAlpha(30),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10
                          ),
                          leading: Icon(Icons.history,
                              color: colorScheme.onSurface
                          ),
                          title: Text(
                            'History',
                            style: textTheme.titleSmall,
                          ),
                          trailing: AnimatedRotation(
                            turns: _historyExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.expand_more,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child: child,
                        );
                      },
                      child: _historyExpanded
                          ? Column(
                        key: const ValueKey(true),
                        children: [
                          for (int i = 0; i < history.length; i++) ...[
                            ListTile(
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6
                              ),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                colorScheme.primaryContainer,
                                child: Icon(Icons.insights,
                                    color: colorScheme
                                        .onPrimaryContainer
                                ),
                              ),
                              title: Text(
                                'Date: ${history[i]['date']}',
                                style: textTheme.bodyLarge
                                    ?.copyWith(
                                    fontWeight:
                                    FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Weight: ${history[i]['weight']} kg | Calories: ${history[i]['calories']} kcal',
                                style: textTheme.bodySmall,
                              ),
                            ),
                            if (i < history.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                          ]
                        ],
                      )
                          : const SizedBox.shrink(
                          key: ValueKey(false)
                      ),
                    ),
                  ],
                ),
              );
            },
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
              style: textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
