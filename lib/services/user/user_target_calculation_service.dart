import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';

class UserTargetCalculationService {
  final Dio _dio = DioClient.instance;

  Future<List<UserTargetCalculation>> fetchUserTargetCalculations() async {
    try {
      final response = await _dio.get('/userTargetCalculations');
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
  }
}
