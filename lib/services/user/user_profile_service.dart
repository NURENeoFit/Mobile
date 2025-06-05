import 'package:dio/dio.dart';
import 'package:neofit_mobile/models/user/personal_user_data.dart';
import 'package:neofit_mobile/models/user/program_goal.dart';
import 'package:neofit_mobile/models/user/user.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';

class UserProfileService {
  final Dio _dio = DioClient.instance;

  Future<FullUserProfile?> fetchUserProfile() async {
    try {
      // 1. Get user data (simulate /me endpoint)
      final userResponse = await _dio.get('/users/1');
      if (userResponse.statusCode != 200) return null;
      final userJson = userResponse.data;

      // 2. Get personal user data by user_id
      final pudResponse = await _dio.get(
        '/personal_user_data',
        queryParameters: {'user_id': userJson['user_id']},
      );
      // json-server returns an array, check if not empty
      if (pudResponse.statusCode != 200 || pudResponse.data.isEmpty) return null;
      final pudJson = pudResponse.data[0];

      // 3. Get the program goal by goal_id
      final goalResponse = await _dio.get('/program_goals/${pudJson['goal_id']}');
      if (goalResponse.statusCode != 200) return null;
      final goalJson = goalResponse.data;

      // Build Dart models from JSON
      final user = User.fromJson(userJson);
      final goal = ProgramGoal.fromJson(goalJson);

      final personalUserData = PersonalUserData(
        goal: goal,
        weightKg: (pudJson['weight_kg'] as num).toDouble(),
        heightCm: (pudJson['height_cm'] as num).toDouble(),
        age: pudJson['age'],
        gender: Gender.values.firstWhere((e) => e.name == pudJson['gender']),
        activityLevel: ActivityLevel.values.firstWhere((e) => e.name == pudJson['activity_level']),
      );

      // Return full user profile object
      return FullUserProfile(
        user: user,
        personalData: personalUserData,
      );
    } catch (e) {
      // Log and handle error
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
