import 'package:dartz/dartz.dart';
import '../../domain/entities/goma_entity.dart';
import '../../domain/repositories/gomas_repository.dart';
import '../datasources/gomas_remote_datasource.dart';
import '../models/goma_model.dart';

class GomasRepositoryImpl implements GomasRepository {
  final GomasRemoteDataSource dataSource;

  GomasRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, List<GomaEntity>>> getGomas(String vehiculoId) async {
    try {
      final models = await dataSource.getGomas(vehiculoId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GomaEntity>> actualizarGoma(
      String gomaId, String estado) async {
    try {
      final model = await dataSource.actualizarGoma(gomaId, estado);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> registrarPinchazo(
      String gomaId, String descripcion, DateTime fecha) async {
    try {
      await dataSource.registrarPinchazo(gomaId, descripcion, fecha);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
