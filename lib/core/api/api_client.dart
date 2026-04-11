import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'api_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeout),
      ),
    );
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
    _initialized = true;
  }

  Dio get dio {
    if (!_initialized) init();
    return _dio;
  }
}
