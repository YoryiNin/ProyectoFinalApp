import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/mantenimientos/domain/usecases/add_fotos_mantenimiento_usecase.dart';
import 'package:taller_itla_app/features/mantenimientos/domain/usecases/get_mantenimiento_detalle_usecase.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/mantenimientos_remote_datasource.dart';
import '../../data/repositories/mantenimientos_repository_impl.dart';
import '../../domain/entities/mantenimiento_entity.dart';
import '../../domain/repositories/mantenimientos_repository.dart';
import '../../domain/usecases/get_mantenimientos_usecase.dart';
import '../../domain/usecases/create_mantenimiento_usecase.dart';

final mantenimientosDataSourceProvider =
    Provider<MantenimientosRemoteDataSource>((ref) {
  return MantenimientosRemoteDataSourceImpl(dio: ApiClient().dio);
});

final mantenimientosRepositoryProvider =
    Provider<MantenimientosRepository>((ref) {
  return MantenimientosRepositoryImpl(
    dataSource: ref.read(mantenimientosDataSourceProvider),
  );
});

final getMantenimientosUseCaseProvider =
    Provider<GetMantenimientosUseCase>((ref) {
  return GetMantenimientosUseCase(ref.read(mantenimientosRepositoryProvider));
});

final getMantenimientoDetalleUseCaseProvider =
    Provider<GetMantenimientoDetalleUseCase>((ref) {
  return GetMantenimientoDetalleUseCase(
      ref.read(mantenimientosRepositoryProvider));
});

final createMantenimientoUseCaseProvider =
    Provider<CreateMantenimientoUseCase>((ref) {
  return CreateMantenimientoUseCase(ref.read(mantenimientosRepositoryProvider));
});

final mantenimientoDetalleProvider =
    FutureProvider.family<MantenimientoEntity, String>((ref, id) async {
  final result = await ref.read(getMantenimientoDetalleUseCaseProvider)(id);
  return result.fold(
    (error) => throw Exception(error),
    (mantenimiento) => mantenimiento,
  );
});

final addFotosMantenimientoUseCaseProvider =
    Provider<AddFotosMantenimientoUseCase>((ref) {
  return AddFotosMantenimientoUseCase(
      ref.read(mantenimientosRepositoryProvider));
});

final mantenimientosListProvider =
    FutureProvider.family<List<MantenimientoEntity>, String>(
        (ref, vehiculoId) async {
  final result = await ref.read(getMantenimientosUseCaseProvider)(vehiculoId);
  return result.fold(
    (error) => throw Exception(error),
    (mantenimientos) => mantenimientos,
  );
});

final mantenimientosFiltradosProvider =
    FutureProvider.family<List<MantenimientoEntity>, (String, String?)>(
        (ref, params) async {
  final result = await ref.read(getMantenimientosUseCaseProvider)(params.$1,
      tipo: params.$2);
  return result.fold(
    (error) => throw Exception(error),
    (mantenimientos) => mantenimientos,
  );
});
