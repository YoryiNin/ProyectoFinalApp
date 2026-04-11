import 'package:dartz/dartz.dart';
import '../entities/catalogo_vehiculo_entity.dart';
import '../repositories/catalogo_repository.dart';

class GetCatalogoDetalleUseCase {
  final CatalogoRepository repository;

  GetCatalogoDetalleUseCase(this.repository);

  Future<Either<String, CatalogoVehiculoEntity>> call(String id) async {
    return await repository.getCatalogoDetalle(id);
  }
}
