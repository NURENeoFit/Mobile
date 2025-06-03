import 'package:dio/dio.dart';
import 'package:neofit_mobile/models/user_meal.dart';

class UserMealService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api'));

  Future<List<UserMeal>> fetchMealsForUser() async {
    // Temporary test data (while backend is not available)
    return [
      UserMeal(
        type: MealType.breakfast,
        calories: 320,
        createdTime: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      UserMeal(
        type: MealType.lunch,
        calories: 700,
        createdTime: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      UserMeal(
        type: MealType.dinner,
        calories: 600,
        createdTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    // Real request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/meals');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => UserMeal.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error fetching meals: $e');
    }

    return [];
    */
  }
}
