import 'package:dartz/dartz.dart';
import '../../domain/entities/gasto_entity.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../../domain/entities/categoria_entity.dart';
import '../../domain/repositories/gi_repository.dart';
import '../datasources/gi_remote_datasource.dart';
import '../models/gasto_model.dart';
import '../models/ingreso_model.dart';
import '../models/categoria_model.dart';

class GIRepositoryImpl implements GIRepository {
  final GIRemoteDataSource dataSource;

  GIRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<CategoriaEntity>>> getCategorias() async {
    try {
      final models = await dataSource.getCategorias();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<GastoEntity>>> getGastos(String vehiculoId) async {
    try {
      final models = await dataSource.getGastos(vehiculoId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GastoEntity>> createGasto(
      Map<String, dynamic> data) async {
    try {
      final model = await dataSource.createGasto(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<IngresoEntity>>> getIngresos(
      String vehiculoId) async {
    try {
      final models = await dataSource.getIngresos(vehiculoId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, IngresoEntity>> createIngreso(
      Map<String, dynamic> data) async {
    try {
      final model = await dataSource.createIngreso(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
