import '../../domain/entities/vehiculo_entity.dart';

class VehiculoModel {
  final String id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final String? fotoUrl;
  final String tipoCarroceria; // NUEVO

  VehiculoModel({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.fotoUrl,
    this.tipoCarroceria = 'sedan', // Por defecto 4 puertas
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return VehiculoModel(
      id: data['id']?.toString() ?? '',
      placa: data['placa'] ?? '',
      chasis: data['chasis'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      anio: int.tryParse(data['anio']?.toString() ?? '0') ?? 0,
      fotoUrl: data['foto'] ?? data['fotoUrl'],
      tipoCarroceria: data['tipoCarroceria'] ?? 'sedan', // NUEVO
    );
  }

  Map<String, dynamic> toJson() => {
        'placa': placa,
        'chasis': chasis,
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'tipoCarroceria': tipoCarroceria, // NUEVO
      };

  VehiculoEntity toEntity() => VehiculoEntity(
        id: id,
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        fotoUrl: fotoUrl,
        tipoCarroceria: tipoCarroceria, // NUEVO
      );
}
