import 'package:dartz/dartz.dart';
import '../entities/mantenimiento_entity.dart';
import '../repositories/mantenimientos_repository.dart';

class AddFotosMantenimientoUseCase {
  final MantenimientosRepository repository;

  AddFotosMantenimientoUseCase(this.repository);

  Future<Either<String, MantenimientoEntity>> call(
    String mantenimientoId,
    List<String> fotosPaths,
  ) async {
    return repository.addFotos(mantenimientoId, fotosPaths);
  }
}
