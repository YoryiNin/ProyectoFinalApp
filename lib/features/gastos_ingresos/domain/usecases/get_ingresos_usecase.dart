import 'package:dartz/dartz.dart';
import '../entities/ingreso_entity.dart';
import '../repositories/gi_repository.dart';

class GetIngresosUseCase {
  final GIRepository repository;

  GetIngresosUseCase(this.repository);

  Future<Either<String, List<IngresoEntity>>> call(String vehiculoId) async {
    return repository.getIngresos(vehiculoId);
  }
}
