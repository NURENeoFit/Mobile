import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalBlock extends StatelessWidget {
  final AsyncValue profileAsync;
  final AsyncValue calcAsync;

  const GoalBlock({
    super.key,
    required this.profileAsync,
    required this.calcAsync,
  });

  Widget _buildGoalContent({
    required BuildContext context,
    required String goalDesc,
    required double percent,
    required String progressText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎯 Goal', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(goalDesc, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(25),
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            progressText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profileAsync.isLoading || calcAsync.isLoading) {
      return const SizedBox.shrink();
    }
    if (profileAsync.hasError || profileAsync.value == null) {
      return _buildGoalContent(
        context: context,
        goalDesc: '—',
        percent: 0.0,
        progressText: '—',
      );
    }

    final profile = profileAsync.value!;
    final goal = profile.personalData.goal;
    final currentWeight = profile.personalData.weightKg;

    if (calcAsync.hasError || (calcAsync.value?.isEmpty ?? true)) {
      return _buildGoalContent(
        context: context,
        goalDesc: goal.toString(),
        percent: 0.0,
        progressText: '—',
      );
    }

    final calculations = calcAsync.value!;
    final latest = calculations.first;
    final lastWeight = latest.calculatedWeight;

    final percent = (currentWeight - lastWeight).abs() < 0.1
        ? 1.0
        : (currentWeight - lastWeight).abs() / (currentWeight == 0 ? 1 : currentWeight);
    final difference = (currentWeight - lastWeight).abs();
    final progressText = '${difference.toStringAsFixed(1)} kg left';

    return _buildGoalContent(
      context: context,
      goalDesc: goal.toString(),
      percent: percent.clamp(0.0, 1.0),
      progressText: progressText,
    );
  }
}
