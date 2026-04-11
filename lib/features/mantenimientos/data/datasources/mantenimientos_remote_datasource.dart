import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/mantenimiento_model.dart';

abstract class MantenimientosRemoteDataSource {
  Future<List<MantenimientoModel>> getMantenimientos(String vehiculoId,
      {String? tipo});
  Future<MantenimientoModel> getMantenimientoDetalle(String id);
  Future<MantenimientoModel> createMantenimiento(
    Map<String, dynamic> data,
    List<String> fotosPaths,
  );
  Future<MantenimientoModel> addFotos(
      String mantenimientoId, List<String> fotosPaths);
}

class MantenimientosRemoteDataSourceImpl
    implements MantenimientosRemoteDataSource {
  final Dio dio;

  MantenimientosRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MantenimientoModel>> getMantenimientos(
    String vehiculoId, {
    String? tipo,
  }) async {
    try {
      final queryParams = <String, dynamic>{'vehiculo_id': vehiculoId};
      if (tipo != null && tipo.isNotEmpty) queryParams['tipo'] = tipo;

      final response = await dio.get(
        '/mantenimientos',
        queryParameters: queryParams,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => MantenimientoModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar mantenimientos: $e');
    }
  }

  @override
  Future<MantenimientoModel> getMantenimientoDetalle(String id) async {
    try {
      final response = await dio.get(
        '/mantenimientos/detalle',
        queryParameters: {'id': id},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return MantenimientoModel.fromJson(response.data['data']);
      }
      throw Exception('Mantenimiento no encontrado');
    } catch (e) {
      throw Exception('Error al cargar detalle: $e');
    }
  }

  @override
  Future<MantenimientoModel> createMantenimiento(
    Map<String, dynamic> data,
    List<String> fotosPaths,
  ) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
      });

      for (int i = 0; i < fotosPaths.length && i < 5; i++) {
        formData.files.add(
          MapEntry(
            'fotos[]',
            await MultipartFile.fromFile(fotosPaths[i]),
          ),
        );
      }

      final response = await dio.post(
        '/mantenimientos',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MantenimientoModel.fromJson(response.data);
      }
      throw Exception(
          response.data['message'] ?? 'Error al crear mantenimiento');
    } catch (e) {
      throw Exception('Error creando mantenimiento: $e');
    }
  }

  @override
  Future<MantenimientoModel> addFotos(
    String mantenimientoId,
    List<String> fotosPaths,
  ) async {
    try {
      final formData = FormData.fromMap({});

      for (int i = 0; i < fotosPaths.length && i < 5; i++) {
        formData.files.add(
          MapEntry(
            'fotos[]',
            await MultipartFile.fromFile(fotosPaths[i]),
          ),
        );
      }

      final response = await dio.post(
        '/mantenimientos/fotos',
        queryParameters: {'id': mantenimientoId},
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200) {
        return MantenimientoModel.fromJson(response.data);
      }
      throw Exception('Error al agregar fotos');
    } catch (e) {
      throw Exception('Error agregando fotos: $e');
    }
  }
}
