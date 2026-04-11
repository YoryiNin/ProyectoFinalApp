import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/tema_model.dart';

abstract class ForoAuthDataSource {
  Future<TemaModel> crearTema(
      String vehiculoId, String titulo, String descripcion);
  Future<RespuestaModel> responderTema(String temaId, String contenido);
  Future<List<TemaModel>> getMisTemas();
}

class ForoAuthDataSourceImpl implements ForoAuthDataSource {
  final Dio dio;

  ForoAuthDataSourceImpl({required this.dio});

  @override
  Future<TemaModel> crearTema(
      String vehiculoId, String titulo, String descripcion) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode({
          'vehiculo_id': vehiculoId,
          'titulo': titulo,
          'descripcion': descripcion,
        }),
      });

      final response = await dio.post(
        '/foro/crear',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📝 Crear tema response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TemaModel.fromJson(response.data['data'] ?? response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al crear tema');
    } catch (e) {
      throw Exception('Error creando tema: $e');
    }
  }

  @override
  Future<RespuestaModel> responderTema(String temaId, String contenido) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode({
          'tema_id': temaId,
          'contenido': contenido,
        }),
      });

      final response = await dio.post(
        '/foro/responder',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('💬 Responder tema response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RespuestaModel.fromJson(response.data['data'] ?? response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al responder');
    } catch (e) {
      throw Exception('Error respondiendo: $e');
    }
  }

  @override
  Future<List<TemaModel>> getMisTemas() async {
    try {
      final response = await dio.get(
        '/foro/mis-temas',
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📋 Mis temas response: ${response.data}');

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => TemaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar mis temas: $e');
    }
  }
}
