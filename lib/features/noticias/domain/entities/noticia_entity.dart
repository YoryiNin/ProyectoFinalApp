class NoticiaEntity {
  final String id;
  final String titulo;
  final String extracto;
  final String imagenUrl;
  final String fecha;
  final String? contenidoHtml;

  const NoticiaEntity({
    required this.id,
    required this.titulo,
    required this.extracto,
    required this.imagenUrl,
    required this.fecha,
    this.contenidoHtml,
  });
}
