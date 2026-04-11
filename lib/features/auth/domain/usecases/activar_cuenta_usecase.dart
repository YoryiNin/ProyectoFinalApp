import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class ActivarCuentaUseCase {
  final AuthRepository repository;
  ActivarCuentaUseCase(this.repository);

  Future<Either<String, UserEntity>> call(String token, String contrasena) =>
      repository.activarCuenta(token, contrasena);
}
