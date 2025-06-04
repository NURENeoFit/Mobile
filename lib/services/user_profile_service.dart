import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';

class UserProfileService {
  final Dio _dio = DioClient.instance;

  Future<FullUserProfile?> fetchUserProfile() async {
    try {
      final response = await _dio.get('/userProfiles/me');
      final data = response.statusCode == 200 ? response.data : null;
      if (data is Map<String, dynamic>) {
        return FullUserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? dob,
    int? roleId,
  }) async {
    try {
      final data = {
        if (firstName != null) 'user_first_name': firstName,
        if (lastName != null) 'user_last_name': lastName,
        if (phone != null) 'user_phone': phone,
        if (email != null) 'user_email': email,
        if (dob != null) 'user_dob': dob,
        if (roleId != null) 'role_id': roleId,
      };
      await _dio.patch('/user/me', data: data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> updatePersonalUserData({
    int? goalId,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
  }) async {
    try {
      final data = {
        if (goalId != null) 'goal_id': goalId,
        if (weight != null) 'weight_kg': weight,
        if (height != null) 'height_cm': height,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (activityLevel != null) 'activity_level': activityLevel,
      };
      await _dio.patch('/personal-user-data/me', data: data);
    } catch (e) {
      print('Error updating personal user data: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchPersonalUserData() async {
    try {
      final response = await _dio.get('/personal-user-data/me');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching personal user data: $e');
    }
    return null;
  }
}
