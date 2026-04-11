import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/foro_public_datasource.dart';
import '../../data/datasources/foro_auth_datasource.dart';
import '../../data/repositories/foro_repository_impl.dart';
import '../../domain/entities/tema_entity.dart';
import '../../domain/repositories/foro_repository.dart';
import '../../domain/usecases/get_temas_publicos_usecase.dart';
import '../../domain/usecases/crear_tema_usecase.dart';
import '../../domain/usecases/responder_tema_usecase.dart';
import '../../domain/usecases/get_mis_temas_usecase.dart';

// DataSources
final foroPublicDataSourceProvider = Provider<ForoPublicDataSource>((ref) {
  return ForoPublicDataSourceImpl(dio: ApiClient().dio);
});

final foroAuthDataSourceProvider = Provider<ForoAuthDataSource>((ref) {
  return ForoAuthDataSourceImpl(dio: ApiClient().dio);
});

// Repository
final foroRepositoryProvider = Provider<ForoRepository>((ref) {
  return ForoRepositoryImpl(
    publicDataSource: ref.read(foroPublicDataSourceProvider),
    authDataSource: ref.read(foroAuthDataSourceProvider),
  );
});

// Use Cases Públicos
final getTemasUseCaseProvider = Provider<GetTemasPublicosUseCase>((ref) {
  return GetTemasPublicosUseCase(ref.read(foroRepositoryProvider));
});

final getTemaDetalleUseCaseProvider = Provider<GetTemaDetalleUseCase>((ref) {
  return GetTemaDetalleUseCase(ref.read(foroRepositoryProvider));
});

// Use Cases Autenticados
final crearTemaUseCaseProvider = Provider<CrearTemaUseCase>((ref) {
  return CrearTemaUseCase(ref.read(foroRepositoryProvider));
});

final responderTemaUseCaseProvider = Provider<ResponderTemaUseCase>((ref) {
  return ResponderTemaUseCase(ref.read(foroRepositoryProvider));
});

final getMisTemasUseCaseProvider = Provider<GetMisTemasUseCase>((ref) {
  return GetMisTemasUseCase(ref.read(foroRepositoryProvider));
});

// Providers
final temasListProvider = FutureProvider<List<TemaEntity>>((ref) async {
  final result = await ref.read(getTemasUseCaseProvider)();
  return result.fold((e) => throw Exception(e), (t) => t);
});

final temaDetalleProvider =
    FutureProvider.family<TemaEntity, String>((ref, id) async {
  final result = await ref.read(getTemaDetalleUseCaseProvider)(id);
  return result.fold((e) => throw Exception(e), (t) => t);
});

final misTemasProvider = FutureProvider<List<TemaEntity>>((ref) async {
  final result = await ref.read(getMisTemasUseCaseProvider)();
  return result.fold((e) => throw Exception(e), (t) => t);
});
