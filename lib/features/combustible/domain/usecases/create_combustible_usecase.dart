import 'package:dartz/dartz.dart';
import '../entities/combustible_entity.dart';
import '../repositories/combustible_repository.dart';

class CreateCombustibleUseCase {
  final CombustibleRepository repository;

  CreateCombustibleUseCase(this.repository);

  Future<Either<String, CombustibleEntity>> call(
    Map<String, dynamic> data,
  ) async {
    return repository.createCombustible(data);
  }
}
