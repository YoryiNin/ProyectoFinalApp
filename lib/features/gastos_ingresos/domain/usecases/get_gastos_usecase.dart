import 'package:dartz/dartz.dart';
import '../entities/gasto_entity.dart';
import '../repositories/gi_repository.dart';

class GetGastosUseCase {
  final GIRepository repository;

  GetGastosUseCase(this.repository);

  Future<Either<String, List<GastoEntity>>> call(String vehiculoId) async {
    return repository.getGastos(vehiculoId);
  }
}
