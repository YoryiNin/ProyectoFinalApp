import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class OlvidarClaveUseCase {
  final AuthRepository repository;
  OlvidarClaveUseCase(this.repository);

  Future<Either<String, void>> call(String matricula) =>
      repository.olvidarClave(matricula);
}
