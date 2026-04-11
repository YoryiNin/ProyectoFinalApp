import 'package:dartz/dartz.dart';
import '../entities/mantenimiento_entity.dart';
import '../repositories/mantenimientos_repository.dart';

class GetMantenimientoDetalleUseCase {
  final MantenimientosRepository repository;

  GetMantenimientoDetalleUseCase(this.repository);

  Future<Either<String, MantenimientoEntity>> call(String id) async {
    return repository.getMantenimientoDetalle(id);
  }
}
