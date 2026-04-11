import 'package:dartz/dartz.dart';
import '../../domain/entities/mantenimiento_entity.dart';
import '../../domain/repositories/mantenimientos_repository.dart';
import '../datasources/mantenimientos_remote_datasource.dart';

class MantenimientosRepositoryImpl implements MantenimientosRepository {
  final MantenimientosRemoteDataSource dataSource;

  MantenimientosRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<MantenimientoEntity>>> getMantenimientos(
    String vehiculoId, {
    String? tipo,
  }) async {
    try {
      final models = await dataSource.getMantenimientos(vehiculoId, tipo: tipo);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MantenimientoEntity>> getMantenimientoDetalle(
      String id) async {
    try {
      final model = await dataSource.getMantenimientoDetalle(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MantenimientoEntity>> createMantenimiento(
    Map<String, dynamic> data,
    List<String> fotosPaths,
  ) async {
    try {
      final model = await dataSource.createMantenimiento(data, fotosPaths);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MantenimientoEntity>> addFotos(
    String mantenimientoId,
    List<String> fotosPaths,
  ) async {
    try {
      final model = await dataSource.addFotos(mantenimientoId, fotosPaths);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
