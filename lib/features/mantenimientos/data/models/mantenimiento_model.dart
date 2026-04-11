import '../../domain/entities/mantenimiento_entity.dart';

class MantenimientoModel {
  final String id;
  final String vehiculoId;
  final String tipo;
  final double costo;
  final String? piezas;
  final DateTime fecha;
  final List<String> fotosUrls;
  final String? taller;
  final String? observaciones;

  MantenimientoModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.costo,
    this.piezas,
    required this.fecha,
    this.fotosUrls = const [],
    this.taller,
    this.observaciones,
  });

  factory MantenimientoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return MantenimientoModel(
      id: data['id']?.toString() ?? '',
      vehiculoId: data['vehiculo_id']?.toString() ??
          data['vehiculoId']?.toString() ??
          '',
      tipo: data['tipo'] ?? '',
      costo: _parseDouble(data['costo']),
      piezas: data['piezas'],
      fecha: DateTime.tryParse(data['fecha'] ?? '') ?? DateTime.now(),
      fotosUrls: _parseFotosUrls(data['fotos'] ?? data['fotosUrls']),
      taller: data['taller'],
      observaciones: data['observaciones'],
    );
  }

  Map<String, dynamic> toJson() => {
        'vehiculo_id': vehiculoId,
        'tipo': tipo,
        'costo': costo,
        'piezas': piezas,
        'fecha': fecha.toIso8601String(),
        'taller': taller,
        'observaciones': observaciones,
      };

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _parseFotosUrls(dynamic fotos) {
    if (fotos == null) return [];
    if (fotos is List) {
      return fotos.map((e) => e.toString()).toList();
    }
    if (fotos is String && fotos.isNotEmpty) {
      return fotos.split(',').map((e) => e.trim()).toList();
    }
    return [];
  }

  MantenimientoEntity toEntity() => MantenimientoEntity(
        id: id,
        vehiculoId: vehiculoId,
        tipo: tipo,
        costo: costo,
        piezas: piezas,
        fecha: fecha,
        fotosUrls: fotosUrls,
        taller: taller,
        observaciones: observaciones,
      );
}
