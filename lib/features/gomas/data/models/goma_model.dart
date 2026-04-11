import '../../domain/entities/goma_entity.dart';

class PinchazoModel {
  final String id;
  final String gomaId;
  final String descripcion;
  final DateTime fecha;

  PinchazoModel({
    required this.id,
    required this.gomaId,
    required this.descripcion,
    required this.fecha,
  });

  factory PinchazoModel.fromJson(Map<String, dynamic> json) {
    return PinchazoModel(
      id: json['id']?.toString() ?? '',
      gomaId: json['goma_id']?.toString() ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
    );
  }

  PinchazoEntity toEntity() => PinchazoEntity(
        id: id,
        gomaId: gomaId,
        descripcion: descripcion,
        fecha: fecha,
      );
}

class GomaModel {
  final String id;
  final String vehiculoId;
  final String posicion;
  final String eje;
  final String estado;
  final List<PinchazoModel> pinchazos;

  GomaModel({
    required this.id,
    required this.vehiculoId,
    required this.posicion,
    required this.eje,
    required this.estado,
    this.pinchazos = const [],
  });

  factory GomaModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    List<PinchazoModel> pinchazosList = [];
    final rawPinchazos = data['pinchazos'];
    if (rawPinchazos is List) {
      pinchazosList =
          rawPinchazos.map((p) => PinchazoModel.fromJson(p)).toList();
    }

    return GomaModel(
      id: data['id']?.toString() ?? '',
      vehiculoId: data['vehiculo_id']?.toString() ?? '',
      posicion: data['posicion'] ?? '',
      eje: data['eje'] ?? '',
      estado: data['estado'] ?? 'regular',
      pinchazos: pinchazosList,
    );
  }

  GomaEntity toEntity() => GomaEntity(
        id: id,
        vehiculoId: vehiculoId,
        posicion: posicion,
        eje: eje,
        estado: _estadoFromString(estado),
        pinchazos: pinchazos.map((p) => p.toEntity()).toList(),
      );

  GomaEstado _estadoFromString(String value) {
    switch (value.toLowerCase()) {
      case 'buena':
        return GomaEstado.buena;
      case 'regular':
        return GomaEstado.regular;
      case 'mala':
        return GomaEstado.mala;
      case 'reemplazada':
        return GomaEstado.reemplazada;
      default:
        return GomaEstado.regular;
    }
  }
}
