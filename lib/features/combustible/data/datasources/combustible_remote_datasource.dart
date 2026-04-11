import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/combustible_model.dart';

abstract class CombustibleRemoteDataSource {
  Future<List<CombustibleModel>> getCombustibles(String vehiculoId,
      {String? tipo});
  Future<CombustibleModel> createCombustible(Map<String, dynamic> data);
}

class CombustibleRemoteDataSourceImpl implements CombustibleRemoteDataSource {
  final Dio dio;

  CombustibleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CombustibleModel>> getCombustibles(String vehiculoId,
      {String? tipo}) async {
    try {
      final queryParams = <String, dynamic>{'vehiculo_id': vehiculoId};
      if (tipo != null && tipo.isNotEmpty) queryParams['tipo'] = tipo;

      final response = await dio.get(
        '/combustibles',
        queryParameters: queryParams,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => CombustibleModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar registros: $e');
    }
  }

  @override
  Future<CombustibleModel> createCombustible(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
      });

      final response = await dio.post(
        '/combustibles',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CombustibleModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al crear registro');
    } catch (e) {
      throw Exception('Error creando registro: $e');
    }
  }
}
