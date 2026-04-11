import 'package:dartz/dartz.dart';
import '../entities/noticia_entity.dart';
import '../repositories/noticias_repository.dart';

class GetNoticiaDetalleUseCase {
  final NoticiasRepository repository;

  GetNoticiaDetalleUseCase(this.repository);

  Future<Either<String, NoticiaEntity>> call(String id) async {
    return await repository.getNoticiaDetalle(id);
  }
}
