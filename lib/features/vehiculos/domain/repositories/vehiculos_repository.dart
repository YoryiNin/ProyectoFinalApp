import 'package:dartz/dartz.dart';
import '../entities/vehiculo_entity.dart';
import '../entities/resumen_financiero_entity.dart';

abstract class VehiculosRepository {
  Future<Either<String, List<VehiculoEntity>>> getVehiculos({
    String? marca,
    String? modelo,
    int? page,
    int? limit,
  });
  Future<Either<String, VehiculoEntity>> getVehiculoDetalle(String id);
  Future<Either<String, VehiculoEntity>> createVehiculo(
    Map<String, dynamic> data,
    String? fotoPath,
  );
  Future<Either<String, VehiculoEntity>> updateVehiculo(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<String, void>> deleteVehiculo(String id);
  Future<Either<String, ResumenFinancieroEntity>> getResumenFinanciero(
    String vehiculoId,
  );
  Future<Either<String, VehiculoEntity>> updateFoto(
    String vehiculoId,
    String fotoPath,
  );
}
