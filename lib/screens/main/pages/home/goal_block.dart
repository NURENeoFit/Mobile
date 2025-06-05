import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/user/user_profile_provider.dart';
import 'package:neofit_mobile/providers/user/user_target_calculation_provider.dart';

class GoalBlock extends ConsumerWidget {
  const GoalBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileNotifierProvider);
    final calcAsync = ref.watch(userTargetCalculationNotifierProvider);

    Widget _buildGoalContent({
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

    if (profileAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (profileAsync.hasError || profileAsync.value == null) {
      return _buildGoalContent(goalDesc: '—', percent: 0.0, progressText: '—');
    }

    final profile = profileAsync.value!;
    final goal = profile.personalData.goal;
    final startWeight = profile.personalData.weightKg;

    if (calcAsync.isLoading) {
      return _buildGoalContent(goalDesc: goal.toString(), percent: 0.0, progressText: '—');
    }
    if (calcAsync.hasError || (calcAsync.value?.isEmpty ?? true)) {
      return _buildGoalContent(goalDesc: goal.toString(), percent: 0.0, progressText: '—');
    }

    final calculations = calcAsync.value!;
    final latest = calculations.first;
    final targetWeight = latest.calculatedWeight;
    final percent = (startWeight - targetWeight).abs() < 0.1
        ? 1.0
        : ((startWeight - latest.calculatedWeight).abs() /
        (startWeight - targetWeight).abs())
        .clamp(0.0, 1.0);
    final left = (latest.calculatedWeight - targetWeight).abs();
    final progressText = '${left.toStringAsFixed(1)} kg left';

    return _buildGoalContent(
      goalDesc: goal.toString(),
      percent: percent,
      progressText: progressText,
    );
  }
}
