import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user_meal.dart';

//TODO: Change link and method
class UserMealService {
  final Dio _dio = DioClient.instance;

  Future<List<UserMeal>> fetchMealsForUser() async {
    try {
      final response = await _dio.get('/userMealsN');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => UserMeal.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error fetching meals: $e');
    }
    return [];
  }

  Future<UserMeal?> getMealByTypeAndDate(MealType type, DateTime date) async {
    try {
      final response = await _dio.get('/userMealsN', queryParameters: {
        'type': type.name,
        'created_time': date.toIso8601String().substring(0, 10), // 'YYYY-MM-DD'
      });
      if (response.statusCode == 200 &&
          response.data is List &&
          (response.data as List).isNotEmpty) {
        return UserMeal.fromJson(response.data[0]);
      }
    } catch (e) {
      print('Error searching meal: $e');
    }
    return null;
  }

  Future<UserMeal?> upsertMealCalories({
    required MealType type,
    required int caloriesToAdd,
    required DateTime date,
  }) async {
    final existingMeal = await getMealByTypeAndDate(type, date);

    if (existingMeal != null) {
      // Update existing meal
      final updatedCalories = existingMeal.calories + caloriesToAdd;
      try {
        final response = await _dio.patch(
          '/userMealsN/${existingMeal.id}', // use "id" as property name
          data: {'calories': updatedCalories},
        );
        if (response.statusCode == 200) {
          return UserMeal.fromJson(response.data);
        }
      } catch (e) {
        print('Error updating meal: $e');
      }
    } else {
      // Create new meal
      try {
        final response = await _dio.post('/userMealsN', data: {
          'type': type.name,
          'calories': caloriesToAdd,
          'created_time': date.toIso8601String().substring(0, 10),
        });
        if (response.statusCode == 201) {
          return UserMeal.fromJson(response.data);
        }
      } catch (e) {
        print('Error creating meal: $e');
      }
    }
    return null;
  }
}
