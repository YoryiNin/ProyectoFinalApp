import 'package:dartz/dartz.dart';
import '../repositories/gomas_repository.dart';

class RegistrarPinchazoUseCase {
  final GomasRepository repository;

  RegistrarPinchazoUseCase(this.repository);

  Future<Either<String, void>> call(
      String gomaId, String descripcion, DateTime fecha) async {
    return repository.registrarPinchazo(gomaId, descripcion, fecha);
  }
}
