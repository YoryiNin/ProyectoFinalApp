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
      print('╔════════════════════════════════════════════════════════════╗');
      print('║ 🚀 CREANDO NUEVO TEMA');
      print('╠════════════════════════════════════════════════════════════╣');
      print('║ 📌 vehiculoId: $vehiculoId');
      print('║ 📌 titulo: $titulo');
      print('║ 📌 descripcion: $descripcion');

      if (vehiculoId.isEmpty) {
        throw Exception('❌ El vehiculoId no puede estar vacío');
      }

      // Construir el payload correctamente
      final Map<String, dynamic> payload = {
        'vehiculo_id': vehiculoId,
        'titulo': titulo,
        'descripcion': descripcion,
      };

      final String jsonString = jsonEncode(payload);
      print('╠════════════════════════════════════════════════════════════╣');
      print('║ 📦 Payload JSON: $jsonString');

      final FormData formData = FormData.fromMap({
        'datax': jsonString,
      });

      print('║ 📡 Enviando petición a: /foro/crear');

      final Response response = await dio.post(
        '/foro/crear',
        data: formData,
        options: Options(
          validateStatus: (status) => status! < 500,
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      print('╠════════════════════════════════════════════════════════════╣');
      print('║ 📡 Status Code: ${response.statusCode}');
      print('║ 📡 Headers: ${response.headers}');
      print('║ 📡 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Verificar estructura de respuesta
        Map<String, dynamic> temaData;

        if (response.data['data'] != null) {
          temaData = response.data['data'];
          print('║ ✅ Usando response.data["data"]');
        } else if (response.data is Map) {
          temaData = response.data;
          print('║ ✅ Usando response.data directamente');
        } else {
          throw Exception('Formato de respuesta inválido');
        }

        print('║ 📦 Tema data: $temaData');

        // Verificar que tenga ID
        if (temaData['id'] == null) {
          print('║ ⚠️ ADVERTENCIA: La respuesta no contiene ID');
          print('║ 🔍 Campos disponibles: ${temaData.keys}');
        }

        final TemaModel nuevoTema = TemaModel.fromJson(temaData);
        print('║ ✅ TEMA CREADO EXITOSAMENTE:');
        print('║    - ID: ${nuevoTema.id}');
        print('║    - Título: ${nuevoTema.titulo}');
        print('║    - Autor: ${nuevoTema.autor}');
        print('╚════════════════════════════════════════════════════════════╝');

        return nuevoTema;
      }

      final String mensaje = response.data['message'] ??
          response.data['error'] ??
          'Error al crear tema (status ${response.statusCode})';
      print('║ ❌ Error del servidor: $mensaje');
      print('╚════════════════════════════════════════════════════════════╝');
      throw Exception(mensaje);
    } on DioException catch (e) {
      print('║ ❌ DioException:');
      print('║    - Type: ${e.type}');
      print('║    - Message: ${e.message}');
      if (e.response != null) {
        print('║    - Status: ${e.response?.statusCode}');
        print('║    - Data: ${e.response?.data}');
      }
      print('╚════════════════════════════════════════════════════════════╝');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      print('║ ❌ Excepción general: $e');
      print('╚════════════════════════════════════════════════════════════╝');
      throw Exception('Error creando tema: $e');
    }
  }

  @override
  Future<RespuestaModel> responderTema(String temaId, String contenido) async {
    try {
      print('🚀 POST /foro/responder');
      print('📌 temaId: $temaId');
      print('📌 contenido: $contenido');

      final Map<String, dynamic> payload = {
        'tema_id': temaId,
        'contenido': contenido,
      };

      final FormData formData = FormData.fromMap({
        'datax': jsonEncode(payload),
      });

      final Response response = await dio.post(
        '/foro/responder',
        data: formData,
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📝 Status code: ${response.statusCode}');
      print('📝 Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respuestaData = response.data['data'] ?? response.data;
        return RespuestaModel.fromJson(respuestaData);
      }

      throw Exception('Error al responder');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error respondiendo: $e');
    }
  }

  @override
  Future<List<TemaModel>> getMisTemas() async {
    try {
      print('🚀 GET /foro/mis-temas');

      final Response response = await dio.get(
        '/foro/mis-temas',
        options: Options(validateStatus: (s) => s! < 500),
      );

      print('📝 Status code: ${response.statusCode}');
      print('📝 Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          print('✅ Mis temas encontrados: ${data.length}');
          return data.map((json) => TemaModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error cargando mis temas: $e');
      return [];
    }
  }
}
