import 'package:dartz/dartz.dart';
import '../entities/video_entity.dart';

abstract class VideosRepository {
  Future<Either<String, List<VideoEntity>>> getVideos();
}
