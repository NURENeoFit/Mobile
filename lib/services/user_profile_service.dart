import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';

class UserProfileService {
  final Dio _dio = DioClient.instance;

  Future<FullUserProfile?> fetchUserProfile() async {
    // Temporary test data (while backend is not available)
    final testJson = {
      'user': {
        'user_id': 1,
        'user_first_name': 'Anna',
        'user_last_name': 'Smith',
        'username': 'anna.smith',
        'user_phone': '+1234567890',
        'user_email': 'anna@example.com',
        'user_hash_password': 'hashed_password',
        'role_id': 2,
        'user_dob': '2006-04-15',
      },
      'personalData': {
        'personal_user_data_id': 42,
        'user_id': 1,
        'goal': {
          'goal_id': 11,
          'goal_type': 'muscleGain', // enum name!
          'description': 'Build muscles',
        },
        'weight_kg': 65.0,
        'height_cm': 170.0,
        'age': 18,
        'gender': 'female', // enum name!
        'activity_level': 'medium', // enum name!
      }
    };

    return FullUserProfile.fromJson(testJson);

    // Real request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/user/profile');
      final data = response.statusCode == 200 ? response.data : null;
      if (data is Map<String, dynamic>) {
        return FullUserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
    */
  }
}
