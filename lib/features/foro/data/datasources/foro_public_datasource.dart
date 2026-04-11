import 'package:dio/dio.dart';
import '../models/tema_model.dart';

abstract class ForoPublicDataSource {
  Future<List<TemaModel>> getTemas();
  Future<TemaModel> getTemaDetalle(String id);
}

class ForoPublicDataSourceImpl implements ForoPublicDataSource {
  final Dio dio;

  ForoPublicDataSourceImpl({required this.dio});

  @override
  Future<List<TemaModel>> getTemas() async {
    try {
      final response = await dio.get(
        '/publico/foro',
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data =
            response.data['data'] is List ? response.data['data'] : [];
        return data.map((json) => TemaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar el foro: $e');
    }
  }

  @override
  Future<TemaModel> getTemaDetalle(String id) async {
    try {
      final response = await dio.get(
        '/publico/foro/detalle',
        queryParameters: {'id': id},
        options: Options(validateStatus: (s) => s! < 500),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return TemaModel.fromJson(response.data['data']);
      }
      throw Exception('Tema no encontrado');
    } catch (e) {
      throw Exception('Error al cargar detalle del tema: $e');
    }
  }
}
