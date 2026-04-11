import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateFotoPerfilUseCase {
  final AuthRepository repository;
  UpdateFotoPerfilUseCase(this.repository);

  Future<Either<String, UserEntity>> call(String filePath) =>
      repository.updateFotoPerfil(filePath);
}
