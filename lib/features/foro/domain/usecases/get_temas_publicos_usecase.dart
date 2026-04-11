import 'package:dartz/dartz.dart';
import '../entities/tema_entity.dart';
import '../repositories/foro_repository.dart';

class GetTemasPublicosUseCase {
  final ForoRepository repository;
  GetTemasPublicosUseCase(this.repository);

  Future<Either<String, List<TemaEntity>>> call() => repository.getTemas();
}

class GetTemaDetalleUseCase {
  final ForoRepository repository;
  GetTemaDetalleUseCase(this.repository);

  Future<Either<String, TemaEntity>> call(String id) =>
      repository.getTemaDetalle(id);
}
