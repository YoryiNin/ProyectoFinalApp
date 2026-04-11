import 'package:dartz/dartz.dart';
import '../entities/categoria_entity.dart';
import '../repositories/gi_repository.dart';

class GetCategoriasUseCase {
  final GIRepository repository;

  GetCategoriasUseCase(this.repository);

  Future<Either<String, List<CategoriaEntity>>> call() async {
    return repository.getCategorias();
  }
}
