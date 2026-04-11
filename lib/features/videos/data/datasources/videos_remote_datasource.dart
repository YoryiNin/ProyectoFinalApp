import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/video_model.dart';

abstract class VideosRemoteDataSource {
  Future<List<VideoModel>> getVideos();
}

class VideosRemoteDataSourceImpl implements VideosRemoteDataSource {
  final Dio dio;

  VideosRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VideoModel>> getVideos() async {
    try {
      final response = await dio.get(ApiEndpoints.videos);

      print('Videos Response status: ${response.statusCode}');
      print('Videos Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['data'] != null) {
        if (response.data['data'] is List) {
          final List<dynamic> data = response.data['data'];
          return data.map((json) => VideoModel.fromJson(json)).toList();
        }
      }

      return [];
    } catch (e) {
      print('Error en getVideos: $e');
      throw Exception('Error al cargar videos: $e');
    }
  }
}
