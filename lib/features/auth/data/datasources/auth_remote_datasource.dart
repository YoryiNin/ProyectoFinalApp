import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:taller_itla_app/features/vehiculos/data/models/vehiculo_model.dart';
import '../models/auth_response_model.dart';
import '../models/perfil_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> registro(String matricula);
  Future<AuthResponseModel> activarCuenta(String token, String contrasena);
  Future<AuthResponseModel> login(String matricula, String contrasena);
  Future<void> olvidarClave(String matricula);
  Future<PerfilModel> getPerfil();
  Future<PerfilModel> updateFotoPerfil(String filePath);
  Future<List<VehiculoModel>> getMisVehiculos();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> registro(String matricula) async {
    try {
      final formData = FormData.fromMap({
        'datax': '{"matricula":"$matricula"}',
      });
      final response = await dio.post(
        '/auth/registro',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('Registro response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error en el registro');
    } catch (e) {
      throw Exception('Error en registro: $e');
    }
  }

  @override
  Future<AuthResponseModel> activarCuenta(
      String token, String contrasena) async {
    try {
      final formData = FormData.fromMap({
        'datax': '{"token":"$token","contrasena":"$contrasena"}',
      });
      final response = await dio.post(
        '/auth/activar',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('Activar response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al activar cuenta');
    } catch (e) {
      throw Exception('Error activando cuenta: $e');
    }
  }

  @override
  Future<AuthResponseModel> login(String matricula, String contrasena) async {
    try {
      final formData = FormData.fromMap({
        'datax': '{"matricula":"$matricula","contrasena":"$contrasena"}',
      });
      final response = await dio.post(
        '/auth/login',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('Login response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      }
      throw Exception(
          response.data['message'] ?? 'Matrícula o contraseña incorrectos');
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  @override
  Future<void> olvidarClave(String matricula) async {
    try {
      final formData = FormData.fromMap({
        'datax': '{"matricula":"$matricula"}',
      });
      await dio.post(
        '/auth/olvidar',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<PerfilModel> getPerfil() async {
    try {
      final response = await dio.get(
        '/perfil',
        options: Options(validateStatus: (s) => s! < 500),
      );
      print('📱 PERFIL RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        return PerfilModel.fromJson(response.data);
      }
      throw Exception('Error al obtener perfil');
    } catch (e) {
      throw Exception('Error perfil: $e');
    }
  }

  @override
  Future<PerfilModel> updateFotoPerfil(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'foto': await MultipartFile.fromFile(filePath),
      });
      final response = await dio.post(
        '/perfil/foto',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );
      if (response.statusCode == 200) {
        return PerfilModel.fromJson(response.data);
      }
      throw Exception('Error al actualizar foto');
    } catch (e) {
      throw Exception('Error foto perfil: $e');
    }
  }

  @override
  Future<List<VehiculoModel>> getMisVehiculos() async {
    try {
      // 🔧 CORREGIDO: Usar endpoint correcto /vehiculos
      final response = await dio.get(
        '/vehiculos', // ← CAMBIADO: antes era /vehiculos/mis-vehiculos
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('🚗 VEHICULOS RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          print('🚗 Vehículos encontrados: ${data.length}');
          return data.map((json) => VehiculoModel.fromJson(json)).toList();
        }
      }

      // Si no encuentra vehículos, retornar lista vacía
      print('⚠️ No se encontraron vehículos');
      return [];
    } on DioException catch (e) {
      print('❌ Error Dio obteniendo vehículos: ${e.message}');
      if (e.response?.statusCode == 404) {
        print('⚠️ Endpoint /vehiculos no encontrado');
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo vehículos: $e');
      return [];
    }
  }
}
