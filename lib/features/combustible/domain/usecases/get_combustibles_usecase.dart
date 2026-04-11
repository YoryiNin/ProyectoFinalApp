import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/combustible/domain/repositories/combustible_repository.dart';
import '../entities/combustible_entity.dart';

class GetCombustiblesUseCase {
  final CombustibleRepository repository;

  GetCombustiblesUseCase(this.repository);

  Future<Either<String, List<CombustibleEntity>>> call(
    String vehiculoId, {
    String? tipo,
  }) async {
    return repository.getCombustibles(vehiculoId, tipo: tipo);
  }
}
