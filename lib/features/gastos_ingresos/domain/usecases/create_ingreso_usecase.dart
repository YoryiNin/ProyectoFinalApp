import 'package:dartz/dartz.dart';
import '../entities/ingreso_entity.dart';
import '../repositories/gi_repository.dart';

class CreateIngresoUseCase {
  final GIRepository repository;

  CreateIngresoUseCase(this.repository);

  Future<Either<String, IngresoEntity>> call(Map<String, dynamic> data) async {
    return repository.createIngreso(data);
  }
}
