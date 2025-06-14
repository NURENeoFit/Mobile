import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user_target_calculation.dart';

//TODO: Change link and method
class UserTargetCalculationService {
  final Dio _dio = DioClient.instance;

  Future<List<UserTargetCalculation>> fetchUserTargetCalculations() async {
    try {
      final response = await _dio.get('/userTargetCalculations/me');
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

  Future<UserTargetCalculation?> fetchLastUserTargetCalculation() async {
    try {
      final list = await fetchUserTargetCalculations();
      if (list.isNotEmpty) {
        list.sort((a, b) => a.calculatedTargetDate.compareTo(b.calculatedTargetDate));
        return list.last;
      }
    } catch (e) {
      print('Error fetching last user target calculation: $e');
    }
    return null;
  }

  Future<UserTargetCalculation?> addUserTargetCalculation(UserTargetCalculation calculation) async {
    try {
      final response = await _dio.post(
        '/userTargetCalculations',
        data: calculation.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserTargetCalculation.fromJson(response.data);
      }
    } catch (e) {
      print('Error adding user target calculation: $e');
    }
    return null;
  }

  Future<UserTargetCalculation?> updateLastUserTargetCalculation(UserTargetCalculation updated) async {
    try {
      final response = await _dio.put(
        '/userTargetCalculations/update-last',
        data: updated.toJson(),
      );
      if (response.statusCode == 200) {
        return UserTargetCalculation.fromJson(response.data);
      }
    } catch (e) {
      print('Error updating target calculation: $e');
    }
    return null;
  }
}
