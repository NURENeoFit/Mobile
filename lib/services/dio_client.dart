import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/auth_storage.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:5000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ))
    ..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    )) //for debugging
    ..interceptors.add(AuthInterceptor());

  static Dio get instance => _dio;
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AuthStorage.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}