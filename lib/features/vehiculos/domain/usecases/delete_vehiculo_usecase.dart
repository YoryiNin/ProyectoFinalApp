import 'package:dartz/dartz.dart';
import '../repositories/vehiculos_repository.dart';

class DeleteVehiculoUseCase {
  final VehiculosRepository repository;
  DeleteVehiculoUseCase(this.repository);

  Future<Either<String, void>> call(String id) async {
    return repository.deleteVehiculo(id);
  }
}
