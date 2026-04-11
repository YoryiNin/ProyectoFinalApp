import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/gi_remote_datasource.dart';
import '../../data/repositories/gi_repository_impl.dart';
import '../../domain/entities/gasto_entity.dart';
import '../../domain/entities/ingreso_entity.dart';
import '../../domain/entities/categoria_entity.dart';
import '../../domain/repositories/gi_repository.dart';
import '../../domain/usecases/get_categorias_usecase.dart';
import '../../domain/usecases/get_gastos_usecase.dart';
import '../../domain/usecases/create_gasto_usecase.dart';
import '../../domain/usecases/get_ingresos_usecase.dart';
import '../../domain/usecases/create_ingreso_usecase.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final giDataSourceProvider = Provider<GIRemoteDataSource>((ref) {
  return GIRemoteDataSourceImpl(dio: ApiClient().dio);
});

final giRepositoryProvider = Provider<GIRepository>((ref) {
  return GIRepositoryImpl(
    dataSource: ref.read(giDataSourceProvider),
  );
});

// ── Use Cases ────────────────────────────────────────────────────────────────

final getCategoriasUseCaseProvider = Provider<GetCategoriasUseCase>((ref) {
  return GetCategoriasUseCase(ref.read(giRepositoryProvider));
});

final getGastosUseCaseProvider = Provider<GetGastosUseCase>((ref) {
  return GetGastosUseCase(ref.read(giRepositoryProvider));
});

final createGastoUseCaseProvider = Provider<CreateGastoUseCase>((ref) {
  return CreateGastoUseCase(ref.read(giRepositoryProvider));
});

final getIngresosUseCaseProvider = Provider<GetIngresosUseCase>((ref) {
  return GetIngresosUseCase(ref.read(giRepositoryProvider));
});

final createIngresoUseCaseProvider = Provider<CreateIngresoUseCase>((ref) {
  return CreateIngresoUseCase(ref.read(giRepositoryProvider));
});

// ── State Providers para filtros ─────────────────────────────────────────────

final gastosFiltroProvider = StateProvider<String>((ref) => '');
final ingresosFiltroProvider = StateProvider<String>((ref) => '');

// ── Providers para listas ────────────────────────────────────────────────────

final categoriasProvider = FutureProvider<List<CategoriaEntity>>((ref) async {
  final result = await ref.read(getCategoriasUseCaseProvider)();
  return result.fold(
    (error) => throw Exception(error),
    (categorias) => categorias,
  );
});

final gastosListProvider = FutureProvider.family<List<GastoEntity>, String>(
  (ref, vehiculoId) async {
    final result = await ref.read(getGastosUseCaseProvider)(vehiculoId);
    return result.fold(
      (error) => throw Exception(error),
      (gastos) => gastos,
    );
  },
);

final ingresosListProvider = FutureProvider.family<List<IngresoEntity>, String>(
  (ref, vehiculoId) async {
    final result = await ref.read(getIngresosUseCaseProvider)(vehiculoId);
    return result.fold(
      (error) => throw Exception(error),
      (ingresos) => ingresos,
    );
  },
);

// ── Providers con filtros ────────────────────────────────────────────────────

final gastosFiltradosProvider =
    FutureProvider.family<List<GastoEntity>, String>(
  (ref, vehiculoId) async {
    final filtro = ref.watch(gastosFiltroProvider);
    final gastos = await ref.watch(gastosListProvider(vehiculoId).future);

    if (filtro.isEmpty) return gastos;

    return gastos.where((gasto) {
      return gasto.categoriaNombre
              .toLowerCase()
              .contains(filtro.toLowerCase()) ||
          gasto.descripcion.toLowerCase().contains(filtro.toLowerCase());
    }).toList();
  },
);

final ingresosFiltradosProvider =
    FutureProvider.family<List<IngresoEntity>, String>(
  (ref, vehiculoId) async {
    final filtro = ref.watch(ingresosFiltroProvider);
    final ingresos = await ref.watch(ingresosListProvider(vehiculoId).future);

    if (filtro.isEmpty) return ingresos;

    return ingresos.where((ingreso) {
      return ingreso.descripcion.toLowerCase().contains(filtro.toLowerCase());
    }).toList();
  },
);

// ── Provider para totales ────────────────────────────────────────────────────

final gastosTotalProvider = FutureProvider.family<double, String>(
  (ref, vehiculoId) async {
    final gastos = await ref.watch(gastosListProvider(vehiculoId).future);
    double total = 0;
    for (var gasto in gastos) {
      total += gasto.monto;
    }
    return total;
  },
);

final ingresosTotalProvider = FutureProvider.family<double, String>(
  (ref, vehiculoId) async {
    final ingresos = await ref.watch(ingresosListProvider(vehiculoId).future);
    double total = 0;
    for (var ingreso in ingresos) {
      total += ingreso.monto;
    }
    return total;
  },
);

// ── Provider para balance (Ingresos - Gastos) ────────────────────────────────

final balanceProvider = FutureProvider.family<double, String>(
  (ref, vehiculoId) async {
    final totalGastos = await ref.watch(gastosTotalProvider(vehiculoId).future);
    final totalIngresos =
        await ref.watch(ingresosTotalProvider(vehiculoId).future);
    return totalIngresos - totalGastos;
  },
);
