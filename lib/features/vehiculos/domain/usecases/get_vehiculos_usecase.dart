import 'package:dartz/dartz.dart';
import '../entities/vehiculo_entity.dart';
import '../repositories/vehiculos_repository.dart';

class GetVehiculosUseCase {
  final VehiculosRepository repository;
  GetVehiculosUseCase(this.repository);

  Future<Either<String, List<VehiculoEntity>>> call({
    String? marca,
    String? modelo,
    int? page,
    int? limit,
  }) async {
    return repository.getVehiculos(
      marca: marca,
      modelo: modelo,
      page: page,
      limit: limit,
    );
  }
}
