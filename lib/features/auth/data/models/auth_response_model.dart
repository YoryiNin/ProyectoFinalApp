import '../../domain/entities/user_entity.dart';

class AuthResponseModel {
  final String token;
  final String? refreshToken;
  final String? id;
  final String? nombre;
  final String? apellido;
  final String? matricula;
  final String? fotoUrl;
  final String? correo;
  final String? rol;
  final String? grupo;
  final String? vehiculoId;

  AuthResponseModel({
    required this.token,
    this.refreshToken,
    this.id,
    this.nombre,
    this.apellido,
    this.matricula,
    this.fotoUrl,
    this.correo,
    this.rol,
    this.grupo,
    this.vehiculoId,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    print('🔍 AuthResponseModel - Datos recibidos: $data');

    return AuthResponseModel(
      token: data['token'] ?? json['token'] ?? '',
      refreshToken: data['refreshToken'] ?? json['refreshToken'],
      id: data['id']?.toString() ?? json['id']?.toString(),
      nombre: data['nombre'] ?? json['nombre'],
      apellido: data['apellido'] ?? json['apellido'] ?? '',
      matricula: data['matricula'] ?? json['matricula'],
      fotoUrl: data['foto'] ?? data['fotoUrl'] ?? json['foto'],
      correo: data['correo'] ?? json['correo'],
      rol: data['rol'] ?? json['rol'],
      grupo: data['grupo'] ?? json['grupo'],
      vehiculoId: data['vehiculo_id']?.toString() ??
          data['vehiculoId']?.toString() ??
          data['auto_id']?.toString(),
    );
  }
}

extension AuthResponseModelX on AuthResponseModel {
  UserEntity toEntity() => UserEntity(
        id: id ?? '',
        nombre: nombre ?? '',
        apellido: apellido ?? '',
        matricula: matricula ?? '',
        token: token,
        refreshToken: refreshToken,
        fotoUrl: fotoUrl,
        correo: correo,
        rol: rol,
        grupo: grupo,
        vehiculoId: vehiculoId,
      );
}
