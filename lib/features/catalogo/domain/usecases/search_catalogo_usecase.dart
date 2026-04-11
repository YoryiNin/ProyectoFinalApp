import 'package:dartz/dartz.dart';
import '../entities/catalogo_vehiculo_entity.dart';
import '../entities/catalogo_filtros.dart';
import '../repositories/catalogo_repository.dart';

class SearchCatalogoUseCase {
  final CatalogoRepository repository;

  SearchCatalogoUseCase(this.repository);

  Future<Either<String, List<CatalogoVehiculoEntity>>> call(
    CatalogoFiltros filtros,
  ) async {
    return await repository.searchCatalogo(filtros);
  }
}
