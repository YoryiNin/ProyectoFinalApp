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
import '../../../auth/presentation/providers/auth_provider.dart';

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

// Provider para obtener el vehículoId (usa el nuevo provider de auth)
final currentUserVehiculoIdProvider = Provider<String>((ref) {
  return ref.watch(authProvider).vehiculoId ?? '';
});

// Providers de datos
final temasListProvider = FutureProvider<List<TemaEntity>>((ref) async {
  try {
    final result = await ref.read(getTemasUseCaseProvider)();
    return result.fold(
      (e) {
        print('❌ Error cargando temas: $e');
        return <TemaEntity>[];
      },
      (t) {
        print('✅ Temas cargados: ${t.length}');
        return t;
      },
    );
  } catch (e) {
    print('❌ Excepción cargando temas: $e');
    return <TemaEntity>[];
  }
});

final temaDetalleProvider =
    FutureProvider.family<TemaEntity, String>((ref, id) async {
  try {
    final result = await ref.read(getTemaDetalleUseCaseProvider)(id);
    return result.fold(
      (e) {
        print('❌ Error cargando detalle: $e');
        throw Exception(e);
      },
      (t) => t,
    );
  } catch (e) {
    print('❌ Excepción cargando detalle: $e');
    throw Exception('Error al cargar detalle');
  }
});

final misTemasProvider = FutureProvider<List<TemaEntity>>((ref) async {
  try {
    final authState = ref.watch(authProvider);
    if (!authState.isAuthenticated) {
      return <TemaEntity>[];
    }

    final result = await ref.read(getMisTemasUseCaseProvider)();
    return result.fold(
      (e) {
        print('❌ Error cargando mis temas: $e');
        return <TemaEntity>[];
      },
      (t) {
        print('✅ Mis temas cargados: ${t.length}');
        return t;
      },
    );
  } catch (e) {
    print('❌ Excepción cargando mis temas: $e');
    return <TemaEntity>[];
  }
});
