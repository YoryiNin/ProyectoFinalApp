import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/features/combustible/presentation/screens/combustible_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/gastos_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/ingresos_screen.dart';
import 'package:taller_itla_app/features/gomas/presentation/screens/gomas_screen.dart';
import 'package:taller_itla_app/features/mantenimientos/presentation/screens/mantenimientos_screen.dart';
import 'package:taller_itla_app/features/vehiculos/domain/entities/resumen_financiero_entity.dart';
import 'package:taller_itla_app/features/vehiculos/domain/entities/vehiculo_entity.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/vehiculos_provider.dart';
import '../widgets/resumen_financiero_widget.dart';
import 'vehiculo_form_screen.dart';

class VehiculoDetalleScreen extends ConsumerStatefulWidget {
  final String vehiculoId;

  const VehiculoDetalleScreen({super.key, required this.vehiculoId});

  @override
  ConsumerState<VehiculoDetalleScreen> createState() =>
      _VehiculoDetalleScreenState();
}

class _VehiculoDetalleScreenState extends ConsumerState<VehiculoDetalleScreen> {
  /// Proxea la URL solo si no está ya proxeada.
  String _proxyUrl(String url) {
    if (url.isEmpty) return '';
    if (url.contains('taller-itla.ia3x.com/api/imagen')) return url;
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  void _navegarAEdicion(VehiculoEntity vehiculo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VehiculoFormScreen(
          vehiculoId: vehiculo.id,
          initialData: {
            'placa': vehiculo.placa,
            'chasis': vehiculo.chasis,
            'marca': vehiculo.marca,
            'modelo': vehiculo.modelo,
            'anio': vehiculo.anio,
          },
        ),
      ),
    );
    if (result == true) {
      ref.invalidate(vehiculoDetalleProvider(widget.vehiculoId));
      ref.invalidate(vehiculosListProvider);
    }
  }

  void _navegarAMantenimientos(VehiculoEntity vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MantenimientosScreen(
          vehiculoId: vehiculo.id,
          vehiculoNombre: vehiculo.nombreCompleto,
        ),
      ),
    ).then((_) => ref.invalidate(resumenFinancieroProvider(widget.vehiculoId)));
  }

  void _navegarACombustible(VehiculoEntity vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CombustibleScreen(
          vehiculoId: vehiculo.id,
          vehiculoNombre: vehiculo.nombreCompleto,
        ),
      ),
    ).then((_) => ref.invalidate(resumenFinancieroProvider(widget.vehiculoId)));
  }

  void _navegarAGomas(VehiculoEntity vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GomasScreen(
          vehiculoId: vehiculo.id,
          vehiculoNombre: vehiculo.nombreCompleto,
        ),
      ),
    );
  }

  void _navegarAGastos(VehiculoEntity vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GastosScreen(
          vehiculoId: vehiculo.id,
          vehiculoNombre: vehiculo.nombreCompleto,
        ),
      ),
    ).then((_) => ref.invalidate(resumenFinancieroProvider(widget.vehiculoId)));
  }

  void _navegarAIngresos(VehiculoEntity vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngresosScreen(
          vehiculoId: vehiculo.id,
          vehiculoNombre: vehiculo.nombreCompleto,
        ),
      ),
    ).then((_) => ref.invalidate(resumenFinancieroProvider(widget.vehiculoId)));
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoAsync = ref.watch(vehiculoDetalleProvider(widget.vehiculoId));
    final resumenAsync =
        ref.watch(resumenFinancieroProvider(widget.vehiculoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detalle del Vehículo', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              vehiculoAsync.whenData((v) => _navegarAEdicion(v));
            },
          ),
        ],
      ),
      body: vehiculoAsync.when(
        data: (vehiculo) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto del vehículo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildFotoVehiculo(vehiculo),
              ),
              const SizedBox(height: 20),

              // Nombre y placa
              Text(vehiculo.nombreCompleto, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vehiculo.displayPlaca,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              _infoRow('Número de Chasis', vehiculo.chasis),
              const SizedBox(height: 32),

              // Gestión
              Text('GESTIÓN DEL VEHÍCULO', style: AppTextStyles.labelMedium),
              const SizedBox(height: 12),
              _buildSectionButton(
                title: 'MANTENIMIENTOS',
                icon: Icons.build_outlined,
                color: AppColors.info,
                onTap: () => _navegarAMantenimientos(vehiculo),
              ),
              const SizedBox(height: 12),
              _buildSectionButton(
                title: 'COMBUSTIBLE Y ACEITE',
                icon: Icons.local_gas_station_outlined,
                color: AppColors.warning,
                onTap: () => _navegarACombustible(vehiculo),
              ),
              const SizedBox(height: 12),
              _buildSectionButton(
                title: 'ESTADO DE GOMAS',
                icon: Icons.grass_outlined,
                color: AppColors.success,
                onTap: () => _navegarAGomas(vehiculo),
              ),
              const SizedBox(height: 12),
              _buildSectionButton(
                title: 'GASTOS',
                icon: Icons.trending_down_outlined,
                color: AppColors.error,
                onTap: () => _navegarAGastos(vehiculo),
              ),
              const SizedBox(height: 12),
              _buildSectionButton(
                title: 'INGRESOS',
                icon: Icons.trending_up_outlined,
                color: AppColors.success,
                onTap: () => _navegarAIngresos(vehiculo),
              ),
              const SizedBox(height: 32),

              // Resumen financiero
              Text('RESUMEN FINANCIERO', style: AppTextStyles.labelMedium),
              const SizedBox(height: 12),
              resumenAsync.when(
                data: (resumen) => ResumenFinancieroWidget(resumen: resumen),
                loading: () => const ResumenFinancieroWidget(
                  resumen: ResumenFinancieroEntity(
                    totalMantenimientos: 0,
                    totalCombustible: 0,
                    totalGastos: 0,
                    totalIngresos: 0,
                    balance: 0,
                  ),
                  isLoading: true,
                ),
                error: (err, _) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Error al cargar resumen financiero',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error al cargar vehículo',
                  style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFotoVehiculo(VehiculoEntity vehiculo) {
    final rawUrl = vehiculo.fotoUrl ?? '';

    if (rawUrl.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.directions_car_outlined,
            size: 80, color: AppColors.textHint),
      );
    }

    return CachedNetworkImage(
      imageUrl: _proxyUrl(rawUrl),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 200,
        color: AppColors.surfaceVariant,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        height: 200,
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.directions_car_outlined,
            size: 64, color: AppColors.textHint),
      ),
    );
  }

  Widget _buildSectionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.titleMedium)),
            const Icon(Icons.chevron_right,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
          const Spacer(),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}
