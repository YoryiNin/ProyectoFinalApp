import 'package:dartz/dartz.dart';
import '../entities/goma_entity.dart';
import '../repositories/gomas_repository.dart';

class ActualizarGomaUseCase {
  final GomasRepository repository;

  ActualizarGomaUseCase(this.repository);

  Future<Either<String, GomaEntity>> call(String gomaId, String estado) async {
    return repository.actualizarGoma(gomaId, estado);
  }
}
