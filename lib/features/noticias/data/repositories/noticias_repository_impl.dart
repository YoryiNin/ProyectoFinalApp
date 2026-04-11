import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/noticias/data/models/datasources/noticias_remote_datasource.dart';
import '../../domain/entities/noticia_entity.dart';
import '../../domain/repositories/noticias_repository.dart';

import '../models/noticia_model.dart';

class NoticiasRepositoryImpl implements NoticiasRepository {
  final NoticiasRemoteDataSource remoteDataSource;

  NoticiasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<NoticiaEntity>>> getNoticias() async {
    try {
      final List<NoticiaModel> models = await remoteDataSource.getNoticias();
      final List<NoticiaEntity> entities = models
          .where((model) => model != null) // Filtra nulos
          .map((model) => model.toEntity())
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, NoticiaEntity>> getNoticiaDetalle(String id) async {
    try {
      final NoticiaModel model = await remoteDataSource.getNoticiaDetalle(id);
      if (model != null) {
        return Right(model.toEntity());
      } else {
        return Left('Noticia no encontrada');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
