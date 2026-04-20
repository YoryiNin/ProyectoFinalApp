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
      print('🚀 GET /foro/temas');

      final response = await dio.get(
        '/foro/temas',
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📝 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          print('✅ Temas encontrados: ${data.length}');
          return data.map((json) => TemaModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }

  @override
  Future<TemaModel> getTemaDetalle(String id) async {
    try {
      print('🚀 GET /foro/detalle?id=$id');

      final response = await dio.get(
        '/foro/detalle',
        queryParameters: {'id': id},
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📝 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          return TemaModel.fromJson(data);
        }
      }
      throw Exception('Tema no encontrado');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error al cargar detalle: $e');
    }
  }
}
