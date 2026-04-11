import 'package:dartz/dartz.dart';
import '../entities/mantenimiento_entity.dart';
import '../repositories/mantenimientos_repository.dart';

class GetMantenimientosUseCase {
  final MantenimientosRepository repository;
  GetMantenimientosUseCase(this.repository);

  Future<Either<String, List<MantenimientoEntity>>> call(
    String vehiculoId, {
    String? tipo,
  }) async {
    return repository.getMantenimientos(vehiculoId, tipo: tipo);
  }
}
