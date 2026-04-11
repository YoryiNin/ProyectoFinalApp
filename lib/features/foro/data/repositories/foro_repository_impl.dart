import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/foro/data/models/tema_model.dart';
import '../../domain/entities/tema_entity.dart';
import '../../domain/repositories/foro_repository.dart';
import '../datasources/foro_public_datasource.dart';
import '../datasources/foro_auth_datasource.dart';

class ForoRepositoryImpl implements ForoRepository {
  final ForoPublicDataSource publicDataSource;
  final ForoAuthDataSource authDataSource;

  ForoRepositoryImpl({
    required this.publicDataSource,
    required this.authDataSource,
  });

  // Públicos
  @override
  Future<Either<String, List<TemaEntity>>> getTemas() async {
    try {
      final models = await publicDataSource.getTemas();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, TemaEntity>> getTemaDetalle(String id) async {
    try {
      final model = await publicDataSource.getTemaDetalle(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Autenticados
  @override
  Future<Either<String, TemaEntity>> crearTema(
      String vehiculoId, String titulo, String descripcion) async {
    try {
      final model =
          await authDataSource.crearTema(vehiculoId, titulo, descripcion);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, RespuestaEntity>> responderTema(
      String temaId, String contenido) async {
    try {
      final model = await authDataSource.responderTema(temaId, contenido);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TemaEntity>>> getMisTemas() async {
    try {
      final models = await authDataSource.getMisTemas();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
