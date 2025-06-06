import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neofit_mobile/providers/user/user_meal_provider.dart';
import 'package:neofit_mobile/screens/main/pages/profile/statistics/widgets/statistics_history.dart';
import 'package:share_plus/share_plus.dart';

import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/models/user_meal.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';
import 'package:neofit_mobile/screens/main/pages/profile/statistics/widgets/statistics_chart.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(userTargetCalculationNotifierProvider);
      ref.invalidate(userMealNotifierProvider);
      ref.invalidate(userProfileNotifierProvider);
    });
  }

  void _shareResult(List<UserTargetCalculation> data, double currentWeight, int heightCm, int todayCalories) {
    if (data.isEmpty) return;
    final latest = data.first;

    final message = '📊 My Progress:\n\n'
        '👤 Current weight: ${currentWeight.toStringAsFixed(1)} kg\n\n'
        '📏 Height: ${heightCm} cm\n\n'
        '🎯 Target date: ${latest.calculatedTargetDate.toIso8601String().split('T').first}\n\n'
        '🏁 Goal weight: ${latest.calculatedWeight.toStringAsFixed(1)} kg\n\n'
        '🔥 Daily calories: ${todayCalories}/${latest.calculatedNormalCalories} kcal\n\n'
        'Tracking my results with Neofit! 💪';

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final calculationsAsync = ref.watch(userTargetCalculationNotifierProvider);
    final mealsAsync = ref.watch(userMealNotifierProvider);
    final profileAsync = ref.watch(userProfileNotifierProvider);

    if (calculationsAsync.isLoading || mealsAsync.isLoading || profileAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (calculationsAsync.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${calculationsAsync.error}')),
      );
    }
    if (mealsAsync.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${mealsAsync.error}')),
      );
    }
    if (profileAsync.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${profileAsync.error}')),
      );
    }

    final List<UserTargetCalculation> data = calculationsAsync.value ?? [];
    final List<UserMeal> meals = mealsAsync.value ?? [];
    final profile = profileAsync.value;

    if (data.isEmpty || profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Statistics', style: textTheme.titleMedium)),
        body: Center(
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
        ),
      );
    }

    final currentWeight = profile.personalData.weightKg;
    final heightCm = profile.personalData.heightCm;

    final int thisYear = DateTime.now().year;
    final List<UserTargetCalculation> weightData = [...data]
      ..sort((a, b) => b.calculatedTargetDate.compareTo(a.calculatedTargetDate));
    final List<UserTargetCalculation> weightDataThisYear = weightData
        .where((e) => e.calculatedTargetDate.year == thisYear)
        .toList();
    final List<UserTargetCalculation> weightDataForChart = [...weightDataThisYear].reversed.toList();

    final spots = weightDataForChart
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.calculatedWeight))
        .toList();

    final double minY = weightDataForChart.isEmpty
        ? 0.0
        : weightDataForChart.map((e) => e.calculatedWeight).reduce((a, b) => a < b ? a : b) - 1.0;
    final double maxY = weightDataForChart.isEmpty
        ? 1.0
        : weightDataForChart.map((e) => e.calculatedWeight).reduce((a, b) => a > b ? a : b) + 1.0;

    final int targetCalories = weightDataThisYear.isEmpty ? 0 : weightDataThisYear.first.calculatedNormalCalories;

    final today = DateTime.now();
    int todayCalories = meals
        .where((meal) =>
    meal.createdTime.year == today.year &&
        meal.createdTime.month == today.month &&
        meal.createdTime.day == today.day)
        .fold(0, (sum, meal) => sum + meal.calories);

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: textTheme.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: StatisticsChart(
                    data: weightDataForChart,
                    latestWeight: weightData.first.calculatedWeight,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
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
          StatisticsHistory(weightData: weightData),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _shareResult(weightData, currentWeight, heightCm, todayCalories),
              icon: const Icon(Icons.share),
              label: const Text('Share Result'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
