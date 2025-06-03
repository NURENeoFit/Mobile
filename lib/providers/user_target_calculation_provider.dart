import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';
import 'package:neofit_mobile/services/user_target_calculation_service.dart';

final userTargetCalculationNotifierProvider =
AsyncNotifierProvider<UserTargetCalculationNotifier, List<UserTargetCalculation>>(
  UserTargetCalculationNotifier.new,
);

class UserTargetCalculationNotifier extends AsyncNotifier<List<UserTargetCalculation>> {
  @override
  Future<List<UserTargetCalculation>> build() async {
    return await UserTargetCalculationService().fetchUserTargetCalculations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await UserTargetCalculationService().fetchUserTargetCalculations();
    state = AsyncData(data);
  }
}
