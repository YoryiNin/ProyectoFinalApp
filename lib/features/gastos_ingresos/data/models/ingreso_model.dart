import '../../domain/entities/ingreso_entity.dart';

class IngresoModel {
  final String id;
  final String vehiculoId;
  final double monto;
  final String descripcion;
  final DateTime fecha;

  IngresoModel({
    required this.id,
    required this.vehiculoId,
    required this.monto,
    required this.descripcion,
    required this.fecha,
  });

  factory IngresoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return IngresoModel(
      id: data['id']?.toString() ?? '',
      vehiculoId: data['vehiculo_id']?.toString() ??
          data['vehiculoId']?.toString() ??
          '',
      monto: _parseDouble(data['monto']),
      descripcion: data['descripcion'] ?? '',
      fecha: DateTime.tryParse(data['fecha'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehiculo_id': vehiculoId,
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
      };

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  IngresoEntity toEntity() => IngresoEntity(
        id: id,
        vehiculoId: vehiculoId,
        monto: monto,
        descripcion: descripcion,
        fecha: fecha,
      );
}
