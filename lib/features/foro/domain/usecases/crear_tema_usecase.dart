import 'package:dartz/dartz.dart';
import '../entities/tema_entity.dart';
import '../repositories/foro_repository.dart';

class CrearTemaUseCase {
  final ForoRepository repository;
  CrearTemaUseCase(this.repository);

  Future<Either<String, TemaEntity>> call(
      String vehiculoId, String titulo, String descripcion) async {
    return repository.crearTema(vehiculoId, titulo, descripcion);
  }
}
