import 'package:dartz/dartz.dart';
import '../entities/combustible_entity.dart';

abstract class CombustibleRepository {
  Future<Either<String, List<CombustibleEntity>>> getCombustibles(
    String vehiculoId, {
    String? tipo,
  });

  Future<Either<String, CombustibleEntity>> createCombustible(
    Map<String, dynamic> data,
  );
}
