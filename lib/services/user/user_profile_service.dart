import 'package:dio/dio.dart';
import 'package:neofit_mobile/models/user/personal_user_data.dart';
import 'package:neofit_mobile/models/user/program_goal.dart';
import 'package:neofit_mobile/models/user/user.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';

//TODO: Change link
class UserProfileService {
  final Dio _dio = DioClient.instance;

  Future<FullUserProfile?> fetchUserProfile() async {
    try {
      final userResponse = await _dio.get('/user/me'); //User/login
      if (userResponse.statusCode != 200) return null;
      final userJson = userResponse.data;

      final pudResponse = await _dio.get('/personal_user_data/me');
      //queryParameters: {'user_id': userJson['user_id']}

      if (pudResponse.statusCode != 200) return null;
      final pudJson = pudResponse.data;

      final goalResponse = await _dio.get('/program_goals/${pudJson['goal_id']}');
      if (goalResponse.statusCode != 200) return null;
      final goalJson = goalResponse.data;

      final user = User.fromJson(userJson);
      final goal = ProgramGoal.fromJson(goalJson);

      final personalUserData = PersonalUserData.fromJson(
        {
          "goal": goal.toJson(),
          ...pudJson
        }
      );

      return FullUserProfile(
        user: user,
        personalData: personalUserData,
      );
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
}
