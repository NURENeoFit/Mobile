import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/services/user/user_target_calculation_service.dart';

final userTargetCalculationNotifierProvider =
AsyncNotifierProvider<UserTargetCalculationNotifier, List<UserTargetCalculation>>(
  UserTargetCalculationNotifier.new,
);

final lastUserTargetCalculationProvider = Provider<UserTargetCalculation?>((ref) {
  final list = ref.watch(userTargetCalculationNotifierProvider).value;
  if (list != null && list.isNotEmpty) {
    return list.last;
  }
  return null;
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

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await UserTargetCalculationService().fetchUserTargetCalculations();
    state = AsyncData(data);
  }

  UserTargetCalculation? getLastCalculation() {
    final list = state.value;
    if (list != null && list.isNotEmpty) {
      return list.last;
    }
    return null;
  }
}
