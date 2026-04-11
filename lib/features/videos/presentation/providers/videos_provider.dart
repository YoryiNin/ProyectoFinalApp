import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/videos_remote_datasource.dart';
import '../../data/repositories/videos_repository_impl.dart';
import '../../domain/repositories/videos_repository.dart';
import '../../domain/usecases/get_videos_usecase.dart';
import '../../domain/entities/video_entity.dart';
import '../../../../core/api/api_client.dart';

// Providers de infraestructura
final videosRemoteDataSourceProvider = Provider<VideosRemoteDataSource>((ref) {
  final dio = ApiClient().dio;
  return VideosRemoteDataSourceImpl(dio: dio);
});

final videosRepositoryProvider = Provider<VideosRepository>((ref) {
  final remoteDataSource = ref.read(videosRemoteDataSourceProvider);
  return VideosRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getVideosUseCaseProvider = Provider<GetVideosUseCase>((ref) {
  final repository = ref.read(videosRepositoryProvider);
  return GetVideosUseCase(repository);
});

// Provider para la lista de videos
final videosListProvider = FutureProvider<List<VideoEntity>>((ref) async {
  final getVideos = ref.read(getVideosUseCaseProvider);
  final result = await getVideos();

  return result.fold(
    (error) => throw Exception(error),
    (videos) => videos,
  );
});

// Provider para filtro de categoría
final categoriaSeleccionadaProvider = StateProvider<String>((ref) => 'Todos');

// Provider para videos filtrados
final videosFiltradosProvider = Provider<List<VideoEntity>>((ref) {
  final videos = ref.watch(videosListProvider).valueOrNull ?? [];
  final categoria = ref.watch(categoriaSeleccionadaProvider);

  if (categoria == 'Todos') {
    return videos;
  }

  return videos.where((video) => video.categoria == categoria).toList();
});

// Provider para lista de categorías únicas
final categoriasProvider = Provider<List<String>>((ref) {
  final videos = ref.watch(videosListProvider).valueOrNull ?? [];
  final categorias = videos.map((v) => v.categoria).toSet().toList();
  return ['Todos', ...categorias];
});
