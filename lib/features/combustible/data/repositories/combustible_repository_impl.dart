import 'package:dartz/dartz.dart';
import '../../domain/entities/combustible_entity.dart';
import '../../domain/repositories/combustible_repository.dart';
import '../datasources/combustible_remote_datasource.dart';
import '../models/combustible_model.dart';

class CombustibleRepositoryImpl implements CombustibleRepository {
  final CombustibleRemoteDataSource dataSource;

  CombustibleRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<CombustibleEntity>>> getCombustibles(
    String vehiculoId, {
    String? tipo,
  }) async {
    try {
      final models = await dataSource.getCombustibles(vehiculoId, tipo: tipo);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CombustibleEntity>> createCombustible(
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await dataSource.createCombustible(data);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
