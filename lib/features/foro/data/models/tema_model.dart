import '../../domain/entities/tema_entity.dart';

class RespuestaModel {
  final String id;
  final String contenido;
  final String autor;
  final String fecha;
  final String? autorFotoUrl;

  RespuestaModel({
    required this.id,
    required this.contenido,
    required this.autor,
    required this.fecha,
    this.autorFotoUrl,
  });

  factory RespuestaModel.fromJson(Map<String, dynamic> json) {
    return RespuestaModel(
      id: json['id']?.toString() ?? '',
      contenido: json['contenido'] ?? json['respuesta'] ?? '',
      autor: json['autor'] ?? json['nombre'] ?? 'Anónimo',
      fecha: json['fecha'] ?? json['created_at'] ?? '',
      autorFotoUrl: json['foto'] ?? json['fotoUrl'] ?? json['autorFoto'],
    );
  }
}

extension RespuestaModelX on RespuestaModel {
  RespuestaEntity toEntity() => RespuestaEntity(
        id: id,
        contenido: contenido,
        autor: autor,
        fecha: fecha,
        autorFotoUrl: autorFotoUrl,
      );
}

class TemaModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String autor;
  final String fecha;
  final String? vehiculo;
  final String? vehiculoFotoUrl;
  final String? autorFotoUrl;
  final int cantidadRespuestas;
  final List<RespuestaModel> respuestas;

  TemaModel({
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

  factory TemaModel.fromJson(Map<String, dynamic> json) {
    List<RespuestaModel> respuestasList = [];
    final rawResp = json['respuestas'];
    if (rawResp is List) {
      respuestasList = rawResp.map((r) => RespuestaModel.fromJson(r)).toList();
    }

    // Determinar la cantidad de respuestas
    int cantidad = 0;
    if (json['totalRespuestas'] != null) {
      cantidad = int.tryParse(json['totalRespuestas'].toString()) ?? 0;
    } else if (json['cantidadRespuestas'] != null) {
      cantidad = int.tryParse(json['cantidadRespuestas'].toString()) ?? 0;
    } else if (rawResp is List) {
      cantidad = rawResp.length;
    }

    return TemaModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? json['contenido'] ?? '',
      autor: json['autor'] ?? json['nombre'] ?? 'Anónimo',
      fecha: json['fecha'] ?? json['created_at'] ?? '',
      vehiculo: json['vehiculo'] ?? json['auto'] ?? json['vehiculo_nombre'],
      vehiculoFotoUrl:
          json['vehiculoFoto'] ?? json['vehiculo_foto'] ?? json['foto'],
      autorFotoUrl:
          json['autorFoto'] ?? json['autor_foto'] ?? json['fotoAutor'],
      cantidadRespuestas: cantidad,
      respuestas: respuestasList,
    );
  }
}

extension TemaModelX on TemaModel {
  TemaEntity toEntity() => TemaEntity(
        id: id,
        titulo: titulo,
        descripcion: descripcion,
        autor: autor,
        fecha: fecha,
        vehiculo: vehiculo,
        vehiculoFotoUrl: vehiculoFotoUrl,
        autorFotoUrl: autorFotoUrl,
        cantidadRespuestas: cantidadRespuestas,
        respuestas: respuestas.map((r) => r.toEntity()).toList(),
      );
}
