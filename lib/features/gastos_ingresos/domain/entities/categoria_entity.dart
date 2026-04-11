class CategoriaEntity {
  final String id;
  final String nombre;
  final String? icono;

  const CategoriaEntity({
    required this.id,
    required this.nombre,
    this.icono,
  });
}
