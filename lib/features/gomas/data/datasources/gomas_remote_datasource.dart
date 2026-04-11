import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/goma_model.dart';

abstract class GomasRemoteDataSource {
  Future<List<GomaModel>> getGomas(String vehiculoId);
  Future<GomaModel> actualizarGoma(String gomaId, String estado);
  Future<void> registrarPinchazo(
      String gomaId, String descripcion, DateTime fecha);
}

class GomasRemoteDataSourceImpl implements GomasRemoteDataSource {
  final Dio dio;

  GomasRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<GomaModel>> getGomas(String vehiculoId) async {
    try {
      final response = await dio.get(
        '/gomas',
        queryParameters: {'vehiculo_id': vehiculoId},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => GomaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar estado de gomas: $e');
    }
  }

  @override
  Future<GomaModel> actualizarGoma(String gomaId, String estado) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode({'estado': estado}),
      });

      final response = await dio.post(
        '/gomas/actualizar',
        queryParameters: {'goma_id': gomaId},
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200) {
        return GomaModel.fromJson(response.data);
      }
      throw Exception('Error al actualizar estado');
    } catch (e) {
      throw Exception('Error actualizando goma: $e');
    }
  }

  @override
  Future<void> registrarPinchazo(
      String gomaId, String descripcion, DateTime fecha) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode({
          'goma_id': gomaId,
          'descripcion': descripcion,
          'fecha': fecha.toIso8601String(),
        }),
      });

      await dio.post(
        '/gomas/pinchazos',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );
    } catch (e) {
      throw Exception('Error registrando pinchazo: $e');
    }
  }
}
