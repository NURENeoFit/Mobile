import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';

class UserTargetCalculationService {
  final Dio _dio = DioClient.instance;

  Future<List<UserTargetCalculation>> fetchUserTargetCalculations() async {
    // Temporary test data (while backend is not available)
    final testData = [
      {
        'user_target_calculation_id': 777,
        'user_id': 123456,
        'calculated_normal_calories': 1800,
        'calculated_weight': 48.0,
        'calculated_target_date': '2024-07-14',
      },
      {
        'user_target_calculation_id': 776,
        'user_id': 123456,
        'calculated_normal_calories': 2200,
        'calculated_weight': 49.6,
        'calculated_target_date': '2024-06-09',
      },
      {
        'user_target_calculation_id': 775,
        'user_id': 123456,
        'calculated_normal_calories': 2450,
        'calculated_weight': 50.0,
        'calculated_target_date': '2024-06-01',
      },
    ];

    return testData
        .map((json) => UserTargetCalculation.fromJson(json))
        .toList();

    // Real request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/user_target_calculations');
      final data = response.statusCode == 200 ? response.data : null;
      if (data is List) {
        return data
            .map<UserTargetCalculation>((item) => UserTargetCalculation.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error fetching user target calculations: $e');
    }
    return [];
    */
  }
}
