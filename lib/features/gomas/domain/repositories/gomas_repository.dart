import 'package:dartz/dartz.dart';
import '../entities/goma_entity.dart';

abstract class GomasRepository {
  Future<Either<String, List<GomaEntity>>> getGomas(String vehiculoId);
  Future<Either<String, GomaEntity>> actualizarGoma(
      String gomaId, String estado);
  Future<Either<String, void>> registrarPinchazo(
      String gomaId, String descripcion, DateTime fecha);
}
