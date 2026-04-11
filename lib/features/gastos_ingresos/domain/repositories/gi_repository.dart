import 'package:dartz/dartz.dart';
import '../entities/gasto_entity.dart';
import '../entities/ingreso_entity.dart';
import '../entities/categoria_entity.dart';

abstract class GIRepository {
  // Categorías
  Future<Either<String, List<CategoriaEntity>>> getCategorias();

  // Gastos
  Future<Either<String, List<GastoEntity>>> getGastos(String vehiculoId);
  Future<Either<String, GastoEntity>> createGasto(Map<String, dynamic> data);

  // Ingresos
  Future<Either<String, List<IngresoEntity>>> getIngresos(String vehiculoId);
  Future<Either<String, IngresoEntity>> createIngreso(
      Map<String, dynamic> data);
}
