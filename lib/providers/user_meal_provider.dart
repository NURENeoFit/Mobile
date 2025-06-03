import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user_meal.dart';
import 'package:neofit_mobile/services/user_meal_service.dart';

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

  Future<void> updateMealCalories(MealType type, int caloriesToAdd) async {
    final currentMeals = <UserMeal>[...(state.value ?? [])];

    final index = currentMeals.indexWhere((meal) => meal.type == type);

    if (index != -1) {
      final updatedMeal = currentMeals[index].copyWith(
        calories: currentMeals[index].calories + caloriesToAdd,
      );
      currentMeals[index] = updatedMeal;
    } else {
      currentMeals.add(UserMeal(
        type: type,
        calories: caloriesToAdd,
        createdTime: DateTime.now(),
      ));
    }

    await UserMealService().saveMeals(currentMeals);
    state = AsyncData(currentMeals);
  }
}
