import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<String, UserEntity>> call(
          String matricula, String contrasena) =>
      repository.login(matricula, contrasena);
}
