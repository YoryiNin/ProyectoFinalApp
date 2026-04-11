import 'package:dio/dio.dart';
import 'package:taller_itla_app/core/api/api_endpoints.dart';
import 'package:taller_itla_app/features/noticias/data/models/noticia_model.dart';

abstract class NoticiasRemoteDataSource {
  Future<List<NoticiaModel>> getNoticias();
  Future<NoticiaModel> getNoticiaDetalle(String id);
}

class NoticiasRemoteDataSourceImpl implements NoticiasRemoteDataSource {
  final Dio dio;

  NoticiasRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NoticiaModel>> getNoticias() async {
    try {
      final response = await dio.get(
        ApiEndpoints.noticias,
        options: Options(
          validateStatus: (status) => status! < 500,
          // ← Se eliminó el header que limpiaba el token de auth
        ),
      );

      print('📰 Noticias status: ${response.statusCode}');
      print('📰 Noticias data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (response.data['data'] is List) {
          final List<dynamic> data = response.data['data'];
          return data.map((json) => NoticiaModel.fromJson(json)).toList();
        }
      } else if (response.statusCode == 401) {
        throw Exception(
            'El endpoint requiere autenticación. Por favor, inicie sesión.');
      }

      return [];
    } catch (e) {
      print('❌ Error en getNoticias: $e');
      throw Exception('Error al cargar noticias: $e');
    }
  }

  @override
  Future<NoticiaModel> getNoticiaDetalle(String id) async {
    try {
      final response = await dio.get(
        ApiEndpoints.noticiaDetalle,
        queryParameters: {'id': id},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('📰 Detalle noticia status: ${response.statusCode}');
      print('📰 Detalle noticia data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (response.data['data'] != null) {
          return NoticiaModel.fromJson(response.data['data']);
        }
      } else if (response.statusCode == 401) {
        throw Exception(
            'El endpoint requiere autenticación. Por favor, inicie sesión.');
      }

      throw Exception('Noticia no encontrada');
    } catch (e) {
      print('❌ Error en getNoticiaDetalle: $e');
      throw Exception('Error al cargar detalle: $e');
    }
  }
}
