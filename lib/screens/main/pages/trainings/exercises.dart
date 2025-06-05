import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neofit_mobile/models/trainings/trainer.dart';
import 'package:neofit_mobile/models/trainings/workout_program.dart';
import 'package:neofit_mobile/providers/trainings/workout_provider.dart';

class TrainingDetailPage extends ConsumerStatefulWidget {
  final WorkoutProgram workoutProgram;
  final Trainer trainer;

  const TrainingDetailPage({
    super.key,
    required this.workoutProgram,
    required this.trainer,
  });

  @override
  ConsumerState<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends ConsumerState<TrainingDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trainerNotifierProvider.notifier).refresh();
    });
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];
    setState(() {
      isFavorite = favoritesJson.contains(widget.workoutProgram.workoutProgramId.toString());
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];
    setState(() {
      if (isFavorite) {
        favoritesJson.remove(widget.workoutProgram.workoutProgramId.toString());
        isFavorite = false;
      } else {
        favoritesJson.add(widget.workoutProgram.workoutProgramId.toString());
        isFavorite = true;
      }
    });
    await prefs.setStringList('favorite_workouts', favoritesJson);
  }

  @override
  Widget build(BuildContext context) {
    final iconData = iconMap[widget.workoutProgram.icon] ?? Icons.fitness_center;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutProgram.name),
        actions: [
          IconButton(
            icon: isFavorite
                ? Icon(Icons.star, color: Colors.amber)
                : Icon(Icons.star_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, size: 60, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.workoutProgram.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.trainer.trainerFirstName} ${widget.trainer.trainerLastName}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration: ${widget.workoutProgram.duration} min',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Program exercises:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: widget.workoutProgram.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.workoutProgram.exercises[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(exercise.name),
                      subtitle: Text(
                        'Duration: ${exercise.duration} min · Calories: ${exercise.burnedCalories}',
                      ),
                      onTap: () {
                        // Navigate to exercise details page if needed
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
