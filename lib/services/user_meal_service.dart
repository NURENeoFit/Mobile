import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neofit_mobile/models/user_meal.dart';

class UserMealService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api'));

  Future<List<UserMeal>> fetchMealsForUser() async {
    // removeMealsFromCache();

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('user_meals');
    final savedAtRaw = prefs.getString('user_meals_saved_at');

    // Check expiration
    if (cached != null && savedAtRaw != null) {
      final savedAt = DateTime.tryParse(savedAtRaw);
      final now = DateTime.now();

      if (savedAt != null && now.difference(savedAt).inDays >= 1) {
        await prefs.remove('user_meals');
        await prefs.remove('user_meals_saved_at');
      }
    }

    // Try again after potential deletion
    final refreshedCache = prefs.getString('user_meals');

    if (refreshedCache != null) {
      final List<dynamic> decoded = jsonDecode(refreshedCache);
      return decoded.map((e) => UserMeal.fromJson(e)).toList();
    }

    // Use test data on first run
    final testMeals = [
      UserMeal(
        type: MealType.breakfast,
        calories: 0,
        createdTime: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      UserMeal(
        type: MealType.lunch,
        calories: 0,
        createdTime: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      UserMeal(
        type: MealType.dinner,
        calories: 0,
        createdTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    await saveMeals(testMeals);
    return testMeals;

    // Real backend request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/meals');

      if (response.statusCode == 200 && response.data is List) {
        final meals = (response.data as List)
            .map((e) => UserMeal.fromJson(e))
            .toList();

        await saveMeals(meals);

        return meals;
      }
    } catch (e) {
      print('Error fetching meals: $e');
    }

    return [];
    */
  }

  Future<void> saveMeals(List<UserMeal> meals) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(meals.map((m) => m.toJson()).toList());
    await prefs.setString('user_meals', encoded);

    // Save the current timestamp
    await prefs.setString('user_meals_saved_at', DateTime.now().toIso8601String());
  }

  Future<void> removeMealsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_meals');
    await prefs.remove('user_meals_saved_at');
  }

}
