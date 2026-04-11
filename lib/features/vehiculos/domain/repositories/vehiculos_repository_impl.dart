import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/vehiculos/data/datasources/vehiculos_remote_datasource.dart';
import '../../domain/entities/vehiculo_entity.dart';
import '../../domain/entities/resumen_financiero_entity.dart';
import '../../domain/repositories/vehiculos_repository.dart';

class VehiculosRepositoryImpl implements VehiculosRepository {
  final VehiculosRemoteDataSource dataSource;

  VehiculosRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<VehiculoEntity>>> getVehiculos({
    String? marca,
    String? modelo,
    int? page,
    int? limit,
  }) async {
    try {
      final models = await dataSource.getVehiculos(
        marca: marca,
        modelo: modelo,
        page: page,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, VehiculoEntity>> getVehiculoDetalle(String id) async {
    try {
      final model = await dataSource.getVehiculoDetalle(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, VehiculoEntity>> createVehiculo(
    Map<String, dynamic> data,
    String? fotoPath,
  ) async {
    try {
      final model = await dataSource.createVehiculo(data, fotoPath);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, VehiculoEntity>> updateVehiculo(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await dataSource.updateVehiculo(id, data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteVehiculo(String id) async {
    try {
      await dataSource.deleteVehiculo(id);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ResumenFinancieroEntity>> getResumenFinanciero(
    String vehiculoId,
  ) async {
    try {
      final model = await dataSource.getResumenFinanciero(vehiculoId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, VehiculoEntity>> updateFoto(
    String vehiculoId,
    String fotoPath,
  ) async {
    try {
      final model = await dataSource.updateFoto(vehiculoId, fotoPath);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
