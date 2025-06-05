import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/models/user_meal.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';
import 'package:neofit_mobile/services/user/user_meal_service.dart';

final userMealsProvider = FutureProvider<List<UserMeal>>((ref) async {
  return await UserMealService().fetchMealsForUser();
});

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  bool _historyExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userTargetCalculationNotifierProvider.notifier).refresh();
    });
  }

  void _shareResult(List<UserTargetCalculation> data) {
    if (data.isEmpty) return;
    final latest = data.first;
    final message = '📊 My Progress:\n\n'
        'Target date: ${latest.calculatedTargetDate.toIso8601String().split('T').first}\n'
        'Weight: ${latest.calculatedWeight} kg\n'
        'Calories: ${latest.calculatedNormalCalories} kcal\n\n'
        'Tracking my results with Neofit!';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final calculationAsync = ref.watch(userTargetCalculationNotifierProvider);
    final mealsAsync = ref.watch(userMealsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: textTheme.titleMedium),
      ),
      body: calculationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Your progress and statistics will be displayed here.',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final List<UserTargetCalculation> weightData = [...data]
            ..sort((a, b) => b.calculatedTargetDate.compareTo(a.calculatedTargetDate));

          final List<UserTargetCalculation> weightDataForChart = [...weightData].reversed.toList();

          final spots = weightDataForChart
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.calculatedWeight))
              .toList();

          final int targetCalories = weightData.first.calculatedNormalCalories;

          // Сумма калорий за сегодня
          final today = DateTime.now();
          int todayCalories = 0;
          if (mealsAsync is AsyncData<List<UserMeal>>) {
            todayCalories = mealsAsync.value
                .where((meal) =>
            meal.createdTime.year == today.year &&
                meal.createdTime.month == today.month &&
                meal.createdTime.day == today.day)
                .fold(0, (sum, meal) => sum + meal.calories);
          }

          return ListView(
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
                            "You're on track to reach ${weightData.first.calculatedWeight} kg",
                            style: textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 220,
                            width: weightDataForChart.length * 70,
                            child: LineChart(
                              LineChartData(
                                minY: weightDataForChart.map((e) => e.calculatedWeight).reduce((a, b) => a < b ? a : b) - 1,
                                maxY: weightDataForChart.map((e) => e.calculatedWeight).reduce((a, b) => a > b ? a : b) + 1,
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
                                        if (index < weightDataForChart.length) {
                                          final date = weightDataForChart[index].calculatedTargetDate;
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              '${date.month}/${date.day}',
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
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text("Today's Calories", style: textTheme.titleSmall),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: targetCalories == 0 ? 0 : todayCalories / targetCalories,
                      backgroundColor: colorScheme.primary.withAlpha(40),
                      color: colorScheme.primary,
                      minHeight: 14,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$todayCalories / $targetCalories kcal',
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              leading: Icon(Icons.history, color: colorScheme.onSurface),
                              title: Text('History', style: textTheme.titleSmall),
                              trailing: AnimatedRotation(
                                turns: _historyExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(Icons.expand_more, color: colorScheme.onSurface),
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
                              for (int i = 0; i < weightData.length; i++) ...[
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: colorScheme.primaryContainer,
                                    child: Icon(Icons.insights, color: colorScheme.onPrimaryContainer),
                                  ),
                                  title: Text(
                                    'Date: ${weightData[i].calculatedTargetDate.toIso8601String().split('T').first}',
                                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    'Weight: ${weightData[i].calculatedWeight} kg | Calories: ${weightData[i].calculatedNormalCalories} kcal',
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                                if (i < weightData.length - 1)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                              ]
                            ],
                          )
                              : const SizedBox.shrink(key: ValueKey(false)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _shareResult(weightData),
                  icon: const Icon(Icons.share),
                  label: const Text('Share Result'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
