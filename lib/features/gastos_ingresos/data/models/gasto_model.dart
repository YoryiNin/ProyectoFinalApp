import '../../domain/entities/gasto_entity.dart';

class GastoModel {
  final String id;
  final String vehiculoId;
  final String categoriaId;
  final String categoriaNombre;
  final double monto;
  final String descripcion;
  final DateTime fecha;

  GastoModel({
    required this.id,
    required this.vehiculoId,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.monto,
    required this.descripcion,
    required this.fecha,
  });

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return GastoModel(
      id: data['id']?.toString() ?? '',
      vehiculoId: data['vehiculo_id']?.toString() ??
          data['vehiculoId']?.toString() ??
          '',
      categoriaId: data['categoria_id']?.toString() ??
          data['categoriaId']?.toString() ??
          '',
      categoriaNombre: data['categoria_nombre'] ?? data['categoria'] ?? '',
      monto: _parseDouble(data['monto']),
      descripcion: data['descripcion'] ?? '',
      fecha: DateTime.tryParse(data['fecha'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehiculo_id': vehiculoId,
        'categoria_id': categoriaId,
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

  GastoEntity toEntity() => GastoEntity(
        id: id,
        vehiculoId: vehiculoId,
        categoriaId: categoriaId,
        categoriaNombre: categoriaNombre,
        monto: monto,
        descripcion: descripcion,
        fecha: fecha,
      );
}
