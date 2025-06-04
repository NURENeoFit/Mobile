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
  }) async {
    try {
      final response = await _dio.post(
        '/custom-register',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      // JSON-server-auth returns { "accessToken": "..." }
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['accessToken'] != null) {
        final token = response.data['accessToken'] as String;
        await AuthStorage.saveToken(token);
        return token;
      } else {
        // Server error, show readable error
        throw Exception("Registration error: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.response?.data ?? e.message}");
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
        '/custom-login',
        data: {
          'username': username,
          'password': password,
        },
      );
      // JSON-server-auth returns { "accessToken": "..." }
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['accessToken'] != null) {
        final token = response.data['accessToken'] as String;
        await AuthStorage.saveToken(token);
        return token;
      } else {
        throw Exception("Login error: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Network error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
