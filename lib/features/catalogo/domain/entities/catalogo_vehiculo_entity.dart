class CatalogoVehiculoEntity {
  final String id;
  final String marca;
  final String modelo;
  final int anio;
  final double precio;
  final String imagenUrl;
  final List<String> galeria;
  final String? combustible;
  final String? transmision;
  final String? color;
  final String? millaje;
  final String? descripcion;
  final String? condicion;

  const CatalogoVehiculoEntity({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.imagenUrl,
    required this.galeria,
    this.combustible,
    this.transmision,
    this.color,
    this.millaje,
    this.descripcion,
    this.condicion,
  });

  String get nombreCompleto => '$marca $modelo $anio';
}
