import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/noticias/domain/entities/noticia_entity.dart';

import '../../data/models/datasources/noticias_remote_datasource.dart';
import '../../data/repositories/noticias_repository_impl.dart';
import '../../domain/repositories/noticias_repository.dart';
import '../../domain/usecases/get_noticias_usecase.dart';
import '../../domain/usecases/get_noticia_detalle_usecase.dart';
import '../../../../core/api/api_client.dart';

// Provider para el DataSource
final noticiasRemoteDataSourceProvider =
    Provider<NoticiasRemoteDataSource>((ref) {
  final dio = ApiClient().dio;
  return NoticiasRemoteDataSourceImpl(dio: dio);
});

// Provider para el Repository
final noticiasRepositoryProvider = Provider<NoticiasRepository>((ref) {
  final remoteDataSource = ref.read(noticiasRemoteDataSourceProvider);
  return NoticiasRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provider para los UseCases
final getNoticiasUseCaseProvider = Provider<GetNoticiasUseCase>((ref) {
  final repository = ref.read(noticiasRepositoryProvider);
  return GetNoticiasUseCase(repository);
});

final getNoticiaDetalleUseCaseProvider =
    Provider<GetNoticiaDetalleUseCase>((ref) {
  final repository = ref.read(noticiasRepositoryProvider);
  return GetNoticiaDetalleUseCase(repository);
});

// Provider para la lista de noticias
final noticiasListProvider = FutureProvider<List<NoticiaEntity>>((ref) async {
  final getNoticias = ref.read(getNoticiasUseCaseProvider);
  final result = await getNoticias();

  return result.fold(
    (error) => throw Exception(error),
    (noticias) => noticias,
  );
});
