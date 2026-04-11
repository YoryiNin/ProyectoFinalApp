import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/gomas_remote_datasource.dart';
import '../../data/repositories/gomas_repository_impl.dart';
import '../../domain/entities/goma_entity.dart';
import '../../domain/repositories/gomas_repository.dart';
import '../../domain/usecases/get_gomas_usecase.dart';
import '../../domain/usecases/actualizar_goma_usecase.dart';
import '../../domain/usecases/registrar_pinchazo_usecase.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final gomasDataSourceProvider = Provider<GomasRemoteDataSource>((ref) {
  return GomasRemoteDataSourceImpl(dio: ApiClient().dio);
});

final gomasRepositoryProvider = Provider<GomasRepository>((ref) {
  return GomasRepositoryImpl(
    dataSource: ref.read(gomasDataSourceProvider),
  );
});

// ── Use Cases ────────────────────────────────────────────────────────────────

final getGomasUseCaseProvider = Provider<GetGomasUseCase>((ref) {
  return GetGomasUseCase(ref.read(gomasRepositoryProvider));
});

final actualizarGomaUseCaseProvider = Provider<ActualizarGomaUseCase>((ref) {
  return ActualizarGomaUseCase(ref.read(gomasRepositoryProvider));
});

final registrarPinchazoUseCaseProvider =
    Provider<RegistrarPinchazoUseCase>((ref) {
  return RegistrarPinchazoUseCase(ref.read(gomasRepositoryProvider));
});

// ── Providers para listas ────────────────────────────────────────────────────

final gomasListProvider =
    FutureProvider.family<List<GomaEntity>, String>((ref, vehiculoId) async {
  final result = await ref.read(getGomasUseCaseProvider)(vehiculoId);
  return result.fold(
    (error) => throw Exception(error),
    (gomas) => gomas,
  );
});
