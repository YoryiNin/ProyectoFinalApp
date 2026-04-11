import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = LocalStorage().getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 → limpiar sesión (el redirect lo maneja el router guard)
    if (err.response?.statusCode == 401) {
      LocalStorage().clearAll();
    }
    handler.next(err);
  }
}
