import 'package:dartz/dartz.dart';
import '../../domain/entities/catalogo_vehiculo_entity.dart';
import '../../domain/entities/catalogo_filtros.dart';
import '../../domain/repositories/catalogo_repository.dart';
import '../datasources/catalogo_remote_datasource.dart';
import '../models/catalogo_vehiculo_model.dart';

class CatalogoRepositoryImpl implements CatalogoRepository {
  final CatalogoRemoteDataSource remoteDataSource;

  CatalogoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CatalogoVehiculoEntity>>> searchCatalogo(
    CatalogoFiltros filtros,
  ) async {
    try {
      final List<CatalogoVehiculoModel> models =
          await remoteDataSource.searchCatalogo(filtros);
      final List<CatalogoVehiculoEntity> entities =
          models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CatalogoVehiculoEntity>> getCatalogoDetalle(
    String id,
  ) async {
    try {
      final CatalogoVehiculoModel model =
          await remoteDataSource.getCatalogoDetalle(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
