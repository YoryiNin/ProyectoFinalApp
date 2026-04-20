import 'dart:math';

import 'package:dio/dio.dart';
import 'package:taller_itla_app/core/storage/local_storage.dart';
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
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
      ),
    );

    // Agregar interceptores
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
      ),
    );

    // Agregar interceptor personalizado para debugging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('╔══════════════════════════════════════════════════════════╗');
          print('║ 🌐 REQUEST: ${options.method} ${options.path}');
          print('╠══════════════════════════════════════════════════════════╣');
          print('║ 📍 URL Completa: ${options.baseUrl}${options.path}');
          print('║ 📦 Headers:');
          options.headers.forEach((key, value) {
            if (key == 'Authorization') {
              final token = value.toString();
              final shortToken =
                  token.length > 30 ? '${token.substring(0, 30)}...' : token;
              print('║    $key: Bearer $shortToken');
            } else {
              print('║    $key: $value');
            }
          });
          if (options.queryParameters.isNotEmpty) {
            print('║ 📝 Query Parameters: ${options.queryParameters}');
          }
          if (options.data != null) {
            print('║ 📦 Body: ${options.data}');
          }
          print('╚══════════════════════════════════════════════════════════╝');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('╔══════════════════════════════════════════════════════════╗');
          print(
              '║ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          print('╠══════════════════════════════════════════════════════════╣');
          print('║ 📦 Response Data: ${response.data}');
          print('╚══════════════════════════════════════════════════════════╝');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('╔══════════════════════════════════════════════════════════╗');
          print('║ ❌ ERROR: ${error.requestOptions.path}');
          print('╠══════════════════════════════════════════════════════════╣');
          print('║ 📡 Status: ${error.response?.statusCode}');
          print('║ 💬 Message: ${error.message}');
          if (error.response?.data != null) {
            print('║ 📦 Error Data: ${error.response?.data}');
          }
          if (error.type == DioExceptionType.connectionTimeout) {
            print('║ ⏰ Timeout: La conexión ha excedido el tiempo límite');
          } else if (error.type == DioExceptionType.connectionError) {
            print('║ 🔌 Error de conexión: Verifica tu internet');
          }
          print('╚══════════════════════════════════════════════════════════╝');
          return handler.next(error);
        },
      ),
    );

    _initialized = true;
    print('✅ ApiClient inicializado correctamente');
    print('📡 Base URL: ${AppConstants.baseUrl}');
  }

  Dio get dio {
    if (!_initialized) init();
    return _dio;
  }

  // Método para debug: obtener token actual
  Future<String?> getCurrentToken() async {
    final storage = LocalStorage();
    return storage.getToken();
  }

  // Método para debug: verificar autenticación
  Future<bool> verifyAuth() async {
    final token = await getCurrentToken();
    if (token == null || token.isEmpty) {
      print('❌ No hay token de autenticación');
      return false;
    }
    print(
        '✅ Token encontrado: ${token.substring(0, min(20, token.length))}...');
    return true;
  }
}
