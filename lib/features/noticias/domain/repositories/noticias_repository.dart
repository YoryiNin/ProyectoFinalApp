import 'package:dartz/dartz.dart';
import '../entities/noticia_entity.dart';

abstract class NoticiasRepository {
  Future<Either<String, List<NoticiaEntity>>> getNoticias();
  Future<Either<String, NoticiaEntity>> getNoticiaDetalle(String id);
}
