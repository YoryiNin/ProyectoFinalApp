import 'package:dartz/dartz.dart';
import '../entities/vehiculo_entity.dart';
import '../repositories/vehiculos_repository.dart';

class GetVehiculoDetalleUseCase {
  final VehiculosRepository repository;
  GetVehiculoDetalleUseCase(this.repository);

  Future<Either<String, VehiculoEntity>> call(String id) async {
    return repository.getVehiculoDetalle(id);
  }
}
