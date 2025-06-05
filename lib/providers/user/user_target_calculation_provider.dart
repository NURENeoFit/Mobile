import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/services/user/user_target_calculation_service.dart';

final userTargetCalculationNotifierProvider =
AsyncNotifierProvider<UserTargetCalculationNotifier, List<UserTargetCalculation>>(
  UserTargetCalculationNotifier.new,
);

final lastUserTargetCalculationProvider = FutureProvider<UserTargetCalculation?>((ref) async {
  return await UserTargetCalculationService().fetchLastUserTargetCalculation();
});

class UserTargetCalculationNotifier extends AsyncNotifier<List<UserTargetCalculation>> {
  @override
  Future<List<UserTargetCalculation>> build() async {
    return await UserTargetCalculationService().fetchUserTargetCalculations();
  }

  Future<void> addCalculation(UserTargetCalculation calculation) async {
    final service = UserTargetCalculationService();
    final created = await service.addUserTargetCalculation(calculation);
    if (created != null) {
      await refresh();
    }
  }

  Future<void> updateLastCalculationIfNeeded(UserTargetCalculation updated) async {
    final service = UserTargetCalculationService();
    final result = await service.updateLastUserTargetCalculation(updated);
    if (result != null) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await UserTargetCalculationService().fetchUserTargetCalculations();
    state = AsyncData(data);
  }
}