import '../../domain/entities/video_entity.dart';

class VideoModel {
  final String id;
  final String youtubeId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String url;
  final String thumbnail;

  VideoModel({
    required this.id,
    required this.youtubeId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.url,
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']?.toString() ?? '',
      youtubeId: json['youtubeId'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      categoria: json['categoria'] ?? '',
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'youtubeId': youtubeId,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'url': url,
      'thumbnail': thumbnail,
    };
  }
}

extension VideoModelX on VideoModel {
  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      youtubeId: youtubeId,
      titulo: titulo,
      descripcion: descripcion,
      categoria: categoria,
      url: url,
      thumbnail: thumbnail,
    );
  }
}
