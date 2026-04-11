import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetPerfilUseCase {
  final AuthRepository repository;
  GetPerfilUseCase(this.repository);

  Future<Either<String, UserEntity>> call() => repository.getPerfil();
}
