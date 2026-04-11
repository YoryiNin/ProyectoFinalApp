import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class RegistroUseCase {
  final AuthRepository repository;
  RegistroUseCase(this.repository);

  Future<Either<String, String>> call(String matricula) =>
      repository.registro(matricula);
}
