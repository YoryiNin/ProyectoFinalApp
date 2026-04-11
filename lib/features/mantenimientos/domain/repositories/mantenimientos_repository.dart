import 'package:dartz/dartz.dart';
import '../entities/mantenimiento_entity.dart';

abstract class MantenimientosRepository {
  Future<Either<String, List<MantenimientoEntity>>> getMantenimientos(
    String vehiculoId, {
    String? tipo,
  });

  Future<Either<String, MantenimientoEntity>> getMantenimientoDetalle(
      String id);

  Future<Either<String, MantenimientoEntity>> createMantenimiento(
    Map<String, dynamic> data,
    List<String> fotosPaths,
  );

  Future<Either<String, MantenimientoEntity>> addFotos(
    String mantenimientoId,
    List<String> fotosPaths,
  );
}
