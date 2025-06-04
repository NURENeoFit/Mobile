import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neofit_mobile/models/user_meal.dart';

class UserMealService {
  final Dio _dio = DioClient.instance;

  Future<List<UserMeal>> fetchMealsForUser() async {
    try {
      final response = await _dio.get('/userMeals');

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
