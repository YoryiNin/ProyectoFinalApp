import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/vehiculo_model.dart';
import '../models/resumen_financiero_model.dart';

abstract class VehiculosRemoteDataSource {
  Future<List<VehiculoModel>> getVehiculos(
      {String? marca, String? modelo, int? page, int? limit});
  Future<VehiculoModel> getVehiculoDetalle(String id);
  Future<VehiculoModel> createVehiculo(
      Map<String, dynamic> data, String? fotoPath);
  Future<VehiculoModel> updateVehiculo(String id, Map<String, dynamic> data);
  Future<void> deleteVehiculo(String id);
  Future<ResumenFinancieroModel> getResumenFinanciero(String vehiculoId);
  Future<VehiculoModel> updateFoto(String vehiculoId, String fotoPath);
}

class VehiculosRemoteDataSourceImpl implements VehiculosRemoteDataSource {
  final Dio dio;

  VehiculosRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VehiculoModel>> getVehiculos({
    String? marca,
    String? modelo,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (marca != null && marca.isNotEmpty) queryParams['marca'] = marca;
      if (modelo != null && modelo.isNotEmpty) queryParams['modelo'] = modelo;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await dio.get(
        '/vehiculos',
        queryParameters: queryParams,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => VehiculoModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar vehículos: $e');
    }
  }

  @override
  Future<VehiculoModel> getVehiculoDetalle(String id) async {
    try {
      final response = await dio.get(
        '/vehiculos/detalle',
        queryParameters: {'id': id},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return VehiculoModel.fromJson(response.data['data']);
      }
      throw Exception('Vehículo no encontrado');
    } catch (e) {
      throw Exception('Error al cargar detalle: $e');
    }
  }

  @override
  Future<VehiculoModel> createVehiculo(
      Map<String, dynamic> data, String? fotoPath) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
        if (fotoPath != null) 'foto': await MultipartFile.fromFile(fotoPath),
      });

      final response = await dio.post(
        '/vehiculos',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VehiculoModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al crear vehículo');
    } catch (e) {
      throw Exception('Error creando vehículo: $e');
    }
  }

  @override
  Future<VehiculoModel> updateVehiculo(
      String id, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
      });

      final response = await dio.post(
        '/vehiculos/editar',
        queryParameters: {'id': id},
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200) {
        return VehiculoModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al actualizar');
    } catch (e) {
      throw Exception('Error actualizando vehículo: $e');
    }
  }

  @override
  Future<void> deleteVehiculo(String id) async {
    try {
      await dio.delete(
        '/vehiculos',
        queryParameters: {'id': id},
        options: Options(validateStatus: (s) => s! < 500),
      );
    } catch (e) {
      throw Exception('Error eliminando vehículo: $e');
    }
  }

  @override
  Future<ResumenFinancieroModel> getResumenFinanciero(String vehiculoId) async {
    try {
      final response = await dio.get(
        '/vehiculos/detalle',
        queryParameters: {'id': vehiculoId},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ResumenFinancieroModel.fromJson(response.data['data']);
      }
      return ResumenFinancieroModel(
        totalMantenimientos: 0,
        totalCombustible: 0,
        totalGastos: 0,
        totalIngresos: 0,
        balance: 0,
      );
    } catch (e) {
      return ResumenFinancieroModel(
        totalMantenimientos: 0,
        totalCombustible: 0,
        totalGastos: 0,
        totalIngresos: 0,
        balance: 0,
      );
    }
  }

  @override
  Future<VehiculoModel> updateFoto(String vehiculoId, String fotoPath) async {
    try {
      final formData = FormData.fromMap({
        'foto': await MultipartFile.fromFile(fotoPath),
      });

      final response = await dio.post(
        '/vehiculos/foto',
        queryParameters: {'id': vehiculoId},
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200) {
        return VehiculoModel.fromJson(response.data);
      }
      throw Exception('Error al actualizar foto');
    } catch (e) {
      throw Exception('Error subiendo foto: $e');
    }
  }
}
