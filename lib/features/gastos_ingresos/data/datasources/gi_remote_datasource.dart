import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/gasto_model.dart';
import '../models/ingreso_model.dart';
import '../models/categoria_model.dart';

abstract class GIRemoteDataSource {
  // Categorías
  Future<List<CategoriaModel>> getCategorias();

  // Gastos
  Future<List<GastoModel>> getGastos(String vehiculoId);
  Future<GastoModel> createGasto(Map<String, dynamic> data);

  // Ingresos
  Future<List<IngresoModel>> getIngresos(String vehiculoId);
  Future<IngresoModel> createIngreso(Map<String, dynamic> data);
}

class GIRemoteDataSourceImpl implements GIRemoteDataSource {
  final Dio dio;

  GIRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoriaModel>> getCategorias() async {
    try {
      final response = await dio.get(
        '/gastos/categorias',
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => CategoriaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar categorías: $e');
    }
  }

  @override
  Future<List<GastoModel>> getGastos(String vehiculoId) async {
    try {
      final response = await dio.get(
        '/gastos',
        queryParameters: {'vehiculo_id': vehiculoId},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => GastoModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar gastos: $e');
    }
  }

  @override
  Future<GastoModel> createGasto(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
      });

      final response = await dio.post(
        '/gastos',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GastoModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al crear gasto');
    } catch (e) {
      throw Exception('Error creando gasto: $e');
    }
  }

  @override
  Future<List<IngresoModel>> getIngresos(String vehiculoId) async {
    try {
      final response = await dio.get(
        '/ingresos',
        queryParameters: {'vehiculo_id': vehiculoId},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => IngresoModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar ingresos: $e');
    }
  }

  @override
  Future<IngresoModel> createIngreso(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap({
        'datax': jsonEncode(data),
      });

      final response = await dio.post(
        '/ingresos',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return IngresoModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Error al crear ingreso');
    } catch (e) {
      throw Exception('Error creando ingreso: $e');
    }
  }
}
