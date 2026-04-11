import '../../domain/entities/categoria_entity.dart';

class CategoriaModel {
  final String id;
  final String nombre;
  final String? icono;

  CategoriaModel({
    required this.id,
    required this.nombre,
    this.icono,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CategoriaModel(
      id: data['id']?.toString() ?? '',
      nombre: data['nombre'] ?? '',
      icono: data['icono'],
    );
  }

  CategoriaEntity toEntity() => CategoriaEntity(
        id: id,
        nombre: nombre,
        icono: icono,
      );
}
