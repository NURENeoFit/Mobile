import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_meal.dart';
import 'package:neofit_mobile/services/user/user_meal_service.dart';

final userMealNotifierProvider =
AsyncNotifierProvider<UserMealNotifier, List<UserMeal>>(
  UserMealNotifier.new,
);

class UserMealNotifier extends AsyncNotifier<List<UserMeal>> {
  @override
  Future<List<UserMeal>> build() async {
    return await UserMealService().fetchMealsForUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await UserMealService().fetchMealsForUser();
    state = AsyncData(data);
  }

  Future<void> updateMealCalories(
      MealType type,
      int caloriesToAdd, {
        DateTime? date,
      }) async {
    final today = date ?? DateTime.now();
    final updatedMeal = await UserMealService().upsertMealCalories(
      type: type,
      caloriesToAdd: caloriesToAdd,
      date: today,
    );
    if (updatedMeal != null) {
      await refresh();
    }
  }
}
