import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/combustible/data/repositories/combustible_repository_impl.dart';
import 'package:taller_itla_app/features/combustible/domain/entities/combustible_entity.dart';
import 'package:taller_itla_app/features/combustible/domain/repositories/combustible_repository.dart';
import 'package:taller_itla_app/features/combustible/domain/usecases/create_combustible_usecase.dart';
import 'package:taller_itla_app/features/combustible/domain/usecases/get_combustibles_usecase.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/combustible_remote_datasource.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final combustibleDataSourceProvider =
    Provider<CombustibleRemoteDataSource>((ref) {
  return CombustibleRemoteDataSourceImpl(dio: ApiClient().dio);
});

final combustibleRepositoryProvider = Provider<CombustibleRepository>((ref) {
  return CombustibleRepositoryImpl(
    dataSource: ref.read(combustibleDataSourceProvider),
  );
});

// ── Use Cases ────────────────────────────────────────────────────────────────

final getCombustiblesUseCaseProvider = Provider<GetCombustiblesUseCase>((ref) {
  return GetCombustiblesUseCase(ref.read(combustibleRepositoryProvider));
});

final createCombustibleUseCaseProvider =
    Provider<CreateCombustibleUseCase>((ref) {
  return CreateCombustibleUseCase(ref.read(combustibleRepositoryProvider));
});

// ── Providers para listas ────────────────────────────────────────────────────

final combustibleListProvider =
    FutureProvider.family<List<CombustibleEntity>, String>(
        (ref, vehiculoId) async {
  final result = await ref.read(getCombustiblesUseCaseProvider)(vehiculoId);
  return result.fold(
    (error) => throw Exception(error),
    (registros) => registros,
  );
});

final combustibleFiltradosProvider =
    FutureProvider.family<List<CombustibleEntity>, (String, String)>(
        (ref, params) async {
  final (vehiculoId, tipo) = params;
  final result =
      await ref.read(getCombustiblesUseCaseProvider)(vehiculoId, tipo: tipo);
  return result.fold(
    (error) => throw Exception(error),
    (registros) => registros,
  );
});
