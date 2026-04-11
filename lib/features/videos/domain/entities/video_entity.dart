class VideoEntity {
  final String id;
  final String youtubeId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String url;
  final String thumbnail;

  const VideoEntity({
    required this.id,
    required this.youtubeId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.url,
    required this.thumbnail,
  });
}
