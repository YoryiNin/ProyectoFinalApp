import 'package:dartz/dartz.dart';
import '../entities/gasto_entity.dart';
import '../repositories/gi_repository.dart';

class CreateGastoUseCase {
  final GIRepository repository;

  CreateGastoUseCase(this.repository);

  Future<Either<String, GastoEntity>> call(Map<String, dynamic> data) async {
    return repository.createGasto(data);
  }
}
