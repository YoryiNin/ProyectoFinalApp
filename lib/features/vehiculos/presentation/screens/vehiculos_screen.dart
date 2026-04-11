import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/core/router/route_names.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/screens/vehiculo_detalle_screen.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/screens/vehiculo_form_screen.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';
import '../providers/vehiculos_provider.dart';
import '../widgets/vehiculo_card.dart';

class VehiculosScreen extends ConsumerWidget {
  const VehiculosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiculosAsync = ref.watch(vehiculosListProvider);

    return MainScaffold(
      currentIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VehiculoFormScreen(),
              ),
            ).then((_) => ref.invalidate(vehiculosListProvider));
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MIS VEHÍCULOS',
                            style: AppTextStyles.headlineMedium),
                        Text('Gestiona tu flota',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    vehiculosAsync.when(
                      data: (lista) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${lista.length} vehículos',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: vehiculosAsync.when(
                  data: (vehiculos) {
                    if (vehiculos.isEmpty) {
                      return _buildEmpty(context);
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async =>
                          ref.invalidate(vehiculosListProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: vehiculos.length,
                        itemBuilder: (ctx, i) => VehiculoCard(
                          vehiculo: vehiculos[i],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VehiculoDetalleScreen(
                                  vehiculoId: vehiculos[i].id,
                                ),
                              ),
                            ).then(
                                (_) => ref.invalidate(vehiculosListProvider));
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, _) => _buildError(ref, err),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined,
              size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('No tienes vehículos registrados',
              style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar tu primer vehículo',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildError(WidgetRef ref, Object err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Error al cargar vehículos',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(vehiculosListProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
