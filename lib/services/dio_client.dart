import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl = 'http://localhost:5000/api';

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
  ))
  // === Logging all requests and responses ===
    ..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    ))
  // === Custom interceptor for token (example) ===
    ..interceptors.add(AuthInterceptor());

  static Dio get instance => _dio;
}

// === Example of a custom interceptor for adding a token ===
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Here you can dynamically get the token (for example, from SecureStorage/SharedPreferences)
    // For example, the token is hardcoded:
    const token = 'YOUR_TOKEN_HERE';
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
