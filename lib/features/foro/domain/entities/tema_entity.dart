class RespuestaEntity {
  final String id;
  final String contenido;
  final String autor;
  final String fecha;
  final String? autorFotoUrl;

  const RespuestaEntity({
    required this.id,
    required this.contenido,
    required this.autor,
    required this.fecha,
    this.autorFotoUrl,
  });
}

class TemaEntity {
  final String id;
  final String titulo;
  final String descripcion;
  final String autor;
  final String fecha;
  final String? vehiculo;
  final String? vehiculoFotoUrl;
  final String? autorFotoUrl;
  final int cantidadRespuestas;
  final List<RespuestaEntity> respuestas;

  const TemaEntity({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.autor,
    required this.fecha,
    this.vehiculo,
    this.vehiculoFotoUrl,
    this.autorFotoUrl,
    required this.cantidadRespuestas,
    this.respuestas = const [],
  });
}
