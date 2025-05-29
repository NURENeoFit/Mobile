import 'package:flutter/material.dart';
import 'package:neofit_mobile/models/workout.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/trainings.dart';

class TrainingDetailPage extends StatelessWidget {
  final Workout workout;

  const TrainingDetailPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final iconData = iconMap[workout.icon] ?? Icons.fitness_center;

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData, size: 80, color: ColorScheme.of(context).primary),
            const SizedBox(height: 24),
            Text(workout.name, style: TextTheme.of(context).titleLarge),
            const SizedBox(height: 8),
            Text(workout.coach, style: TextTheme.of(context).bodyMedium),
            const SizedBox(height: 24),
            Text(
              'This is a detailed view of the workout "${workout.name}". '
                  'Here will be displayed duration, sets, reps, instructions or video.',
              style: TextTheme.of(context).bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
