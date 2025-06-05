import 'package:dio/dio.dart';

class BackendAuthService {
  final Dio _dio = Dio();

  // Returns your own accessToken
  Future<String?> signInWithGoogleIdToken(String idToken) async {
    try {
      final response = await _dio.post(
        'http://YOUR_SERVER_ADDRESS:5000/auth/google',
        data: {'idToken': idToken},
      );
      // Parse and return accessToken
      return response.data['accessToken'];
    } catch (e) {
      print('Backend Google auth error: $e');
      return null;
    }
  }
}
