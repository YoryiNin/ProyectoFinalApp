import 'package:dartz/dartz.dart';
import '../entities/tema_entity.dart';
import '../repositories/foro_repository.dart';

class ResponderTemaUseCase {
  final ForoRepository repository;
  ResponderTemaUseCase(this.repository);

  Future<Either<String, RespuestaEntity>> call(
      String temaId, String contenido) async {
    return repository.responderTema(temaId, contenido);
  }
}
