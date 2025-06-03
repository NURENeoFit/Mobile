import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';

class UserProfileService {
  final Dio _dio = DioClient.instance;

  Future<FullUserProfile?> fetchUserProfile() async {
    try {
      final response = await _dio.get('/userProfiles');
      final data = response.statusCode == 200 ? response.data : null;
      if (data is Map<String, dynamic>) {
        return FullUserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }

    return null;
  }
}
