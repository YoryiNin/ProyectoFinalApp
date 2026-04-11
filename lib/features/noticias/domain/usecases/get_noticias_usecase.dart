import 'package:dartz/dartz.dart';
import '../entities/noticia_entity.dart';
import '../repositories/noticias_repository.dart';

class GetNoticiasUseCase {
  final NoticiasRepository repository;

  GetNoticiasUseCase(this.repository);

  Future<Either<String, List<NoticiaEntity>>> call() async {
    return await repository.getNoticias();
  }
}
