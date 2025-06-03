import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/schedule/training.dart';
import 'package:neofit_mobile/services/training_service.dart';

final trainingNotifierProvider =
AsyncNotifierProvider<TrainingNotifier, Map<DateTime, List<Training>>>(
  TrainingNotifier.new,
);

class TrainingNotifier extends AsyncNotifier<Map<DateTime, List<Training>>> {
  @override
  Future<Map<DateTime, List<Training>>> build() async {
    return await TrainingService().fetchTrainingsForUserGroupedByDate();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await TrainingService().fetchTrainingsForUserGroupedByDate();
    state = AsyncData(data);
  }
}
