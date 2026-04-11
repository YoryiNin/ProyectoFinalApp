import 'package:dartz/dartz.dart';
import '../entities/vehiculo_entity.dart';
import '../repositories/vehiculos_repository.dart';

class CreateVehiculoUseCase {
  final VehiculosRepository repository;
  CreateVehiculoUseCase(this.repository);

  Future<Either<String, VehiculoEntity>> call(
    Map<String, dynamic> data,
    String? fotoPath,
  ) async {
    return repository.createVehiculo(data, fotoPath);
  }
}
