import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/vehiculos/domain/repositories/vehiculos_repository_impl.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/vehiculos_remote_datasource.dart';

import '../../domain/entities/vehiculo_entity.dart';
import '../../domain/entities/resumen_financiero_entity.dart';
import '../../domain/repositories/vehiculos_repository.dart';
import '../../domain/usecases/get_vehiculos_usecase.dart';
import '../../domain/usecases/get_vehiculo_detalle_usecase.dart';
import '../../domain/usecases/create_vehiculo_usecase.dart';
import '../../domain/usecases/update_vehiculo_usecase.dart';
import '../../domain/usecases/delete_vehiculo_usecase.dart';

// ── Infraestructura ──────────────────────────────────────────────────────────

final vehiculosDataSourceProvider = Provider<VehiculosRemoteDataSource>((ref) {
  return VehiculosRemoteDataSourceImpl(dio: ApiClient().dio);
});

final vehiculosRepositoryProvider = Provider<VehiculosRepository>((ref) {
  return VehiculosRepositoryImpl(
    dataSource: ref.read(vehiculosDataSourceProvider),
  );
});

final getVehiculosUseCaseProvider = Provider<GetVehiculosUseCase>((ref) {
  return GetVehiculosUseCase(ref.read(vehiculosRepositoryProvider));
});

final getVehiculoDetalleUseCaseProvider =
    Provider<GetVehiculoDetalleUseCase>((ref) {
  return GetVehiculoDetalleUseCase(ref.read(vehiculosRepositoryProvider));
});

final createVehiculoUseCaseProvider = Provider<CreateVehiculoUseCase>((ref) {
  return CreateVehiculoUseCase(ref.read(vehiculosRepositoryProvider));
});

final updateVehiculoUseCaseProvider = Provider<UpdateVehiculoUseCase>((ref) {
  return UpdateVehiculoUseCase(ref.read(vehiculosRepositoryProvider));
});

final deleteVehiculoUseCaseProvider = Provider<DeleteVehiculoUseCase>((ref) {
  return DeleteVehiculoUseCase(ref.read(vehiculosRepositoryProvider));
});

// ── Estado ───────────────────────────────────────────────────────────────────

final vehiculosListProvider = FutureProvider<List<VehiculoEntity>>((ref) async {
  final result = await ref.read(getVehiculosUseCaseProvider)();
  return result.fold(
    (error) => throw Exception(error),
    (vehiculos) => vehiculos,
  );
});

final vehiculoDetalleProvider =
    FutureProvider.family<VehiculoEntity, String>((ref, id) async {
  final result = await ref.read(getVehiculoDetalleUseCaseProvider)(id);
  return result.fold(
    (error) => throw Exception(error),
    (vehiculo) => vehiculo,
  );
});

final resumenFinancieroProvider =
    FutureProvider.family<ResumenFinancieroEntity, String>((ref, id) async {
  final result =
      await ref.read(vehiculosRepositoryProvider).getResumenFinanciero(id);
  return result.fold(
    (error) => throw Exception(error),
    (resumen) => resumen,
  );
});
