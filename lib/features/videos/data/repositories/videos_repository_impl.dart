import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/videos/domain/repositories/videos_repository.dart';
import '../../domain/entities/video_entity.dart';
import '../datasources/videos_remote_datasource.dart';
import '../models/video_model.dart';

class VideosRepositoryImpl implements VideosRepository {
  final VideosRemoteDataSource remoteDataSource;

  VideosRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<VideoEntity>>> getVideos() async {
    try {
      final List<VideoModel> models = await remoteDataSource.getVideos();
      final List<VideoEntity> entities = models
          .where((model) => model != null)
          .map((model) => model.toEntity())
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
