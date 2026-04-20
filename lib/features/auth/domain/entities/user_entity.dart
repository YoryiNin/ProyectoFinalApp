class UserEntity {
  final String id;
  final String nombre;
  final String apellido;
  final String matricula;
  final String? fotoUrl;
  final String? correo;
  final String? rol;
  final String? grupo;
  final String token;
  final String? refreshToken;
  final String? vehiculoId;

  const UserEntity({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.matricula,
    required this.token,
    this.fotoUrl,
    this.correo,
    this.rol,
    this.grupo,
    this.refreshToken,
    this.vehiculoId,
  });

  String get nombreCompleto => '$nombre $apellido'.trim();

  UserEntity copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? matricula,
    String? token,
    String? fotoUrl,
    String? correo,
    String? rol,
    String? grupo,
    String? refreshToken,
    String? vehiculoId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      matricula: matricula ?? this.matricula,
      token: token ?? this.token,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      correo: correo ?? this.correo,
      rol: rol ?? this.rol,
      grupo: grupo ?? this.grupo,
      refreshToken: refreshToken ?? this.refreshToken,
      vehiculoId: vehiculoId ?? this.vehiculoId,
    );
  }
}
