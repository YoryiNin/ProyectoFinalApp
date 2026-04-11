import 'package:dartz/dartz.dart';
import '../entities/mantenimiento_entity.dart';
import '../repositories/mantenimientos_repository.dart';

class CreateMantenimientoUseCase {
  final MantenimientosRepository repository;
  CreateMantenimientoUseCase(this.repository);

  Future<Either<String, MantenimientoEntity>> call(
    Map<String, dynamic> data,
    List<String> fotosPaths,
  ) async {
    return repository.createMantenimiento(data, fotosPaths);
  }
}
