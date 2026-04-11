import '../../domain/entities/noticia_entity.dart';

class NoticiaModel {
  final String id;
  final String titulo;
  final String extracto;
  final String imagenUrl;
  final String fecha;
  final String? contenidoHtml;
  final String? link;
  final String? fuente;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.extracto,
    required this.imagenUrl,
    required this.fecha,
    this.contenidoHtml,
    this.link,
    this.fuente,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    return NoticiaModel(
      id: json['id']?.toString() ?? '',
      titulo: json['titulo'] ?? '',
      // La API devuelve "resumen", no "extracto"
      extracto: json['resumen'] ?? json['extracto'] ?? '',
      // La API devuelve "imagenUrl", no "imagen"
      imagenUrl: json['imagenUrl'] ?? json['imagen'] ?? '',
      fecha: json['fecha'] ?? '',
      contenidoHtml: json['contenido'],
      link: json['link'],
      fuente: json['fuente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'resumen': extracto,
      'imagenUrl': imagenUrl,
      'fecha': fecha,
      'contenido': contenidoHtml,
      'link': link,
      'fuente': fuente,
    };
  }
}

extension NoticiaModelX on NoticiaModel {
  NoticiaEntity toEntity() {
    return NoticiaEntity(
      id: id,
      titulo: titulo,
      extracto: extracto,
      imagenUrl: imagenUrl,
      fecha: fecha,
      contenidoHtml: contenidoHtml,
    );
  }
}
