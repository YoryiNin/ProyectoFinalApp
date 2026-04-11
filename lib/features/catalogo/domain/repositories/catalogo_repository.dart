import 'package:dartz/dartz.dart';
import '../entities/catalogo_vehiculo_entity.dart';
import '../entities/catalogo_filtros.dart';

abstract class CatalogoRepository {
  Future<Either<String, List<CatalogoVehiculoEntity>>> searchCatalogo(
    CatalogoFiltros filtros,
  );

  Future<Either<String, CatalogoVehiculoEntity>> getCatalogoDetalle(String id);
}
