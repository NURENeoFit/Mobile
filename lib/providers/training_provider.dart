import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/schedule/training.dart';
import 'package:neofit_mobile/services/training_service.dart';

final trainingNotifierProvider =
AsyncNotifierProvider<TrainingNotifier, List<Training>>(
  TrainingNotifier.new,
);

class TrainingNotifier extends AsyncNotifier<List<Training>> {
  @override
  Future<List<Training>> build() async {
    return await TrainingService().fetchTrainingsForUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await TrainingService().fetchTrainingsForUser();
    state = AsyncData(data);
  }
}
