import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/catalogo_vehiculo_model.dart';
import '../../domain/entities/catalogo_filtros.dart';

abstract class CatalogoRemoteDataSource {
  Future<List<CatalogoVehiculoModel>> searchCatalogo(CatalogoFiltros filtros);
  Future<CatalogoVehiculoModel> getCatalogoDetalle(String id);
}

class CatalogoRemoteDataSourceImpl implements CatalogoRemoteDataSource {
  final Dio dio;

  CatalogoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CatalogoVehiculoModel>> searchCatalogo(
    CatalogoFiltros filtros,
  ) async {
    try {
      final response = await dio.get(
        ApiEndpoints.catalogo,
        queryParameters: filtros.toQueryParams(),
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Catálogo Response status: ${response.statusCode}');
      print('Catálogo Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['data'] != null) {
        if (response.data['data'] is List) {
          final List<dynamic> data = response.data['data'];
          return data
              .map((json) => CatalogoVehiculoModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error en searchCatalogo: $e');
      throw Exception('Error al cargar el catálogo: $e');
    }
  }

  @override
  Future<CatalogoVehiculoModel> getCatalogoDetalle(String id) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.catalogo}/detalle',
        queryParameters: {'id': id},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return CatalogoVehiculoModel.fromJson(response.data['data']);
      }

      throw Exception('Vehículo no encontrado');
    } catch (e) {
      throw Exception('Error al cargar detalle: $e');
    }
  }
}
