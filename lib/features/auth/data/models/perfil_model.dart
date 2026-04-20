import '../../domain/entities/user_entity.dart';

class PerfilModel {
  final String id;
  final String nombre;
  final String apellido;
  final String matricula;
  final String? correo;
  final String? fotoUrl;
  final String? rol;
  final String? grupo;
  final String? vehiculoId;

  PerfilModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.matricula,
    this.correo,
    this.fotoUrl,
    this.rol,
    this.grupo,
    this.vehiculoId,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PerfilModel(
      id: data['id']?.toString() ?? '',
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      matricula: data['matricula'] ?? '',
      correo: data['correo'],
      fotoUrl: data['foto'] ?? data['fotoUrl'],
      rol: data['rol'],
      grupo: data['grupo'],
      vehiculoId:
          data['vehiculo_id']?.toString() ?? data['vehiculoId']?.toString(),
    );
  }
}

extension PerfilModelX on PerfilModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        nombre: nombre,
        apellido: apellido,
        matricula: matricula,
        token: '',
        fotoUrl: fotoUrl,
        correo: correo,
        rol: rol,
        grupo: grupo,
        vehiculoId: vehiculoId,
      );
}
