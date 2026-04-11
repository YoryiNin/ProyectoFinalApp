import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/catalogo_remote_datasource.dart';
import '../../data/repositories/catalogo_repository_impl.dart';
import '../../domain/entities/catalogo_vehiculo_entity.dart';
import '../../domain/entities/catalogo_filtros.dart';
import '../../domain/repositories/catalogo_repository.dart';
import '../../domain/usecases/search_catalogo_usecase.dart';
import '../../domain/usecases/get_catalogo_detalle_usecase.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final catalogoRemoteDataSourceProvider =
    Provider<CatalogoRemoteDataSource>((ref) {
  final dio = ApiClient().dio;
  return CatalogoRemoteDataSourceImpl(dio: dio);
});

final catalogoRepositoryProvider = Provider<CatalogoRepository>((ref) {
  final remoteDataSource = ref.read(catalogoRemoteDataSourceProvider);
  return CatalogoRepositoryImpl(remoteDataSource: remoteDataSource);
});

final searchCatalogoUseCaseProvider = Provider<SearchCatalogoUseCase>((ref) {
  final repository = ref.read(catalogoRepositoryProvider);
  return SearchCatalogoUseCase(repository);
});

final getCatalogoDetalleUseCaseProvider =
    Provider<GetCatalogoDetalleUseCase>((ref) {
  final repository = ref.read(catalogoRepositoryProvider);
  return GetCatalogoDetalleUseCase(repository);
});

// ── Estado de filtros ────────────────────────────────────────────────────────

final catalogoFiltrosProvider =
    StateNotifierProvider<CatalogoFiltrosNotifier, CatalogoFiltros>((ref) {
  return CatalogoFiltrosNotifier();
});

class CatalogoFiltrosNotifier extends StateNotifier<CatalogoFiltros> {
  CatalogoFiltrosNotifier() : super(const CatalogoFiltros());

  void setMarca(String? marca) {
    state = state.copyWith(marca: marca ?? '');
  }

  void setModelo(String? modelo) {
    state = state.copyWith(modelo: modelo ?? '');
  }

  void setAnio(String? anio) {
    state = state.copyWith(anio: anio ?? '');
  }

  void setPrecioMin(String? precioMin) {
    state = state.copyWith(precioMin: precioMin ?? '');
  }

  void setPrecioMax(String? precioMax) {
    state = state.copyWith(precioMax: precioMax ?? '');
  }

  void limpiarFiltros() {
    state = const CatalogoFiltros();
  }
}

// ── Lista del catálogo (reacciona a los filtros) ─────────────────────────────

final catalogoListProvider =
    FutureProvider<List<CatalogoVehiculoEntity>>((ref) async {
  final filtros = ref.watch(catalogoFiltrosProvider);
  final searchCatalogo = ref.read(searchCatalogoUseCaseProvider);
  final result = await searchCatalogo(filtros);

  return result.fold(
    (error) => throw Exception(error),
    (vehiculos) => vehiculos,
  );
});

// ── Detalle de un vehículo ───────────────────────────────────────────────────

final catalogoDetalleProvider =
    FutureProvider.family<CatalogoVehiculoEntity, String>((ref, id) async {
  final getDetalle = ref.read(getCatalogoDetalleUseCaseProvider);
  final result = await getDetalle(id);

  return result.fold(
    (error) => throw Exception(error),
    (vehiculo) => vehiculo,
  );
});
