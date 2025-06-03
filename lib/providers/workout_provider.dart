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
