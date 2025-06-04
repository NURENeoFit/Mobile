import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/utils/auth_storage.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  // Registration
  Future<String?> register({
    required String username,
    required String password,
    required String email,
    // add other fields if needed
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'username': username,
          'password': password,
          'email': email,
          // add other fields here
        },
      );
      // Assume API returns { "token": "..." }
      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'] as String;
        await AuthStorage.saveToken(token);
        return token;
      } else {
        throw Exception("Registration error: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // Login
  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      // Assume API returns { "token": "..." }
      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'] as String;
        await AuthStorage.saveToken(token);
        return token;
      } else {
        throw Exception("Login error: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
