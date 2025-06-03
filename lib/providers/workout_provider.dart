import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/trainer.dart';
import 'package:neofit_mobile/services/workout_service.dart';

final trainerNotifierProvider = AsyncNotifierProvider<TrainerNotifier, List<Trainer>>(
  TrainerNotifier.new,
);

class TrainerNotifier extends AsyncNotifier<List<Trainer>> {
  @override
  Future<List<Trainer>> build() async {
    return await TrainerService().fetchTrainersWithProgramsAndExercises();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await TrainerService().fetchTrainersWithProgramsAndExercises();
    state = AsyncData(data);
  }
}

const Map<String, IconData> iconMap = {
  'fitness_center': Icons.fitness_center,
  'directions_run': Icons.directions_run,
  'self_improvement': Icons.self_improvement,
  'sports': Icons.sports,
  'sports_martial_arts': Icons.sports_martial_arts,
  'accessibility': Icons.accessibility,
  'accessibility_new': Icons.accessibility_new,
  'music_note': Icons.music_note,
};
