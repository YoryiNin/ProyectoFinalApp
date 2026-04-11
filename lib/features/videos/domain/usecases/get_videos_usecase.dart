import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/videos/domain/repositories/videos_repository.dart';
import '../entities/video_entity.dart';

class GetVideosUseCase {
  final VideosRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<String, List<VideoEntity>>> call() async {
    return await repository.getVideos();
  }
}
