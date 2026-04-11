class VehiculoEntity {
  final String id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final String? fotoUrl;
  final String tipoCarroceria; // NUEVO: 'sedan', 'coupe', 'suv', 'hatchback'

  const VehiculoEntity({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    this.fotoUrl,
    this.tipoCarroceria = 'sedan', // Por defecto 4 puertas
  });

  String get nombreCompleto => '$marca $modelo $anio';
  String get displayPlaca => placa.toUpperCase();

  // Mostrar tipo de carrocería en texto
  String get displayCarroceria {
    switch (tipoCarroceria) {
      case 'coupe':
        return '2 Puertas (Coupé)';
      case 'sedan':
        return '4 Puertas (Sedán)';
      case 'suv':
        return '5 Puertas (SUV)';
      case 'hatchback':
        return '5 Puertas (Hatchback)';
      default:
        return '4 Puertas';
    }
  }

  // Saber si es un coupé (2 puertas)
  bool get isCoupe => tipoCarroceria == 'coupe';

  // Saber cuántas puertas tiene
  int get numeroPuertas {
    switch (tipoCarroceria) {
      case 'coupe':
        return 2;
      case 'sedan':
        return 4;
      case 'suv':
        return 5;
      case 'hatchback':
        return 5;
      default:
        return 4;
    }
  }

  // Método copyWith para actualizar
  VehiculoEntity copyWith({
    String? id,
    String? placa,
    String? chasis,
    String? marca,
    String? modelo,
    int? anio,
    String? fotoUrl,
    String? tipoCarroceria,
  }) {
    return VehiculoEntity(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      chasis: chasis ?? this.chasis,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      tipoCarroceria: tipoCarroceria ?? this.tipoCarroceria,
    );
  }
}
