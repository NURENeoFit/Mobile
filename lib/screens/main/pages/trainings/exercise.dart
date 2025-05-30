import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:neofit_mobile/models/workout.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/trainings.dart';

class TrainingDetailPage extends StatefulWidget {
  final Workout workout;

  const TrainingDetailPage({super.key, required this.workout});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];
    setState(() {
      isFavorite = favoritesJson.contains(widget.workout.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];

    setState(() {
      if (isFavorite) {
        favoritesJson.remove(widget.workout.id);
        isFavorite = false;
      } else {
        favoritesJson.add(widget.workout.id);
        isFavorite = true;
      }
    });

    await prefs.setStringList('favorite_workouts', favoritesJson);
  }

  @override
  Widget build(BuildContext context) {
    final iconData = iconMap[widget.workout.icon] ?? Icons.fitness_center;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name, style: TextTheme.of(context).headlineMedium),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData, size: 80, color: ColorScheme.of(context).primary),
            const SizedBox(height: 24),
            Text(widget.workout.name, style: TextTheme.of(context).titleMedium),
            const SizedBox(height: 8),
            Text(widget.workout.coach, style: TextTheme.of(context).bodyLarge),
            const SizedBox(height: 24),
            Text(
              'This is a detailed view of the workout "${widget.workout.name}". '
                  'Here will be displayed duration, sets, reps, instructions or video.',
              style: TextTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
