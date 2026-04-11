import 'package:dartz/dartz.dart';
import '../entities/vehiculo_entity.dart';
import '../repositories/vehiculos_repository.dart';

class UpdateVehiculoUseCase {
  final VehiculosRepository repository;
  UpdateVehiculoUseCase(this.repository);

  Future<Either<String, VehiculoEntity>> call(
    String id,
    Map<String, dynamic> data,
  ) async {
    return repository.updateVehiculo(id, data);
  }
}
