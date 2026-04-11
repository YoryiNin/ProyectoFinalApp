import '../../domain/entities/catalogo_vehiculo_entity.dart';

class CatalogoVehiculoModel {
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

  CatalogoVehiculoModel({
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

  factory CatalogoVehiculoModel.fromJson(Map<String, dynamic> json) {
    // Parsear galería de imágenes (puede venir como List o String separado por comas)
    List<String> galeriaList = [];
    final galeriaRaw = json['galeria'] ?? json['imagenes'] ?? json['fotos'];
    if (galeriaRaw is List) {
      galeriaList = galeriaRaw.map((e) => e.toString()).toList();
    } else if (galeriaRaw is String && galeriaRaw.isNotEmpty) {
      galeriaList = galeriaRaw.split(',').map((e) => e.trim()).toList();
    }

    // Si no hay galería, usar la imagen principal
    final imagenPrincipal = json['imagen'] ?? json['foto'] ?? '';
    if (galeriaList.isEmpty && imagenPrincipal.isNotEmpty) {
      galeriaList = [imagenPrincipal];
    }

    // Parsear precio (puede venir como String o num)
    double precioVal = 0;
    final precioRaw = json['precio'];
    if (precioRaw is num) {
      precioVal = precioRaw.toDouble();
    } else if (precioRaw is String) {
      precioVal = double.tryParse(
              precioRaw.replaceAll(',', '').replaceAll('RD\$', '').trim()) ??
          0;
    }

    return CatalogoVehiculoModel(
      id: json['id']?.toString() ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      anio: int.tryParse(json['anio']?.toString() ?? '0') ?? 0,
      precio: precioVal,
      imagenUrl: imagenPrincipal,
      galeria: galeriaList,
      combustible: json['combustible'],
      transmision: json['transmision'],
      color: json['color'],
      millaje: json['millaje']?.toString(),
      descripcion: json['descripcion'],
      condicion: json['condicion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'precio': precio,
      'imagen': imagenUrl,
      'galeria': galeria,
      'combustible': combustible,
      'transmision': transmision,
      'color': color,
      'millaje': millaje,
      'descripcion': descripcion,
      'condicion': condicion,
    };
  }
}

extension CatalogoVehiculoModelX on CatalogoVehiculoModel {
  CatalogoVehiculoEntity toEntity() {
    return CatalogoVehiculoEntity(
      id: id,
      marca: marca,
      modelo: modelo,
      anio: anio,
      precio: precio,
      imagenUrl: imagenUrl,
      galeria: galeria,
      combustible: combustible,
      transmision: transmision,
      color: color,
      millaje: millaje,
      descripcion: descripcion,
      condicion: condicion,
    );
  }
}
