import '../../domain/entities/combustible_entity.dart';

class CombustibleModel {
  final String id;
  final String vehiculoId;
  final String tipo;
  final double cantidad;
  final String unidad;
  final double monto;
  final DateTime fecha;

  CombustibleModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.monto,
    required this.fecha,
  });

  factory CombustibleModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CombustibleModel(
      id: data['id']?.toString() ?? '',
      vehiculoId: data['vehiculo_id']?.toString() ??
          data['vehiculoId']?.toString() ??
          '',
      tipo: data['tipo'] ?? '',
      cantidad: _parseDouble(data['cantidad']),
      unidad: data['unidad'] ?? '',
      monto: _parseDouble(data['monto']),
      fecha: DateTime.tryParse(data['fecha'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehiculo_id': vehiculoId,
        'tipo': tipo,
        'cantidad': cantidad,
        'unidad': unidad,
        'monto': monto,
        'fecha': fecha.toIso8601String(),
      };

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  CombustibleEntity toEntity() => CombustibleEntity(
        id: id,
        vehiculoId: vehiculoId,
        tipo: tipo,
        cantidad: cantidad,
        unidad: unidad,
        monto: monto,
        fecha: fecha,
      );
}
