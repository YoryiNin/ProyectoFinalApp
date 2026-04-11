import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/mantenimientos_provider.dart';
import '../widgets/photo_gallery_widget.dart';

class MantenimientoDetalleScreen extends ConsumerWidget {
  final String mantenimientoId;

  const MantenimientoDetalleScreen({super.key, required this.mantenimientoId});

  String _proxyUrl(String url) =>
      'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el provider correcto
    final mantenimientoAsync = ref.watch(
      mantenimientoDetalleProvider(mantenimientoId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detalle Mantenimiento', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: mantenimientoAsync.when(
        data: (mantenimiento) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mantenimiento.tipoIcon,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(mantenimiento.tipo, style: AppTextStyles.labelMedium),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Información principal
              _infoCard(
                icon: Icons.attach_money,
                label: 'Costo',
                value: mantenimiento.costoFormatted,
              ),
              const SizedBox(height: 12),

              if (mantenimiento.piezas != null &&
                  mantenimiento.piezas!.isNotEmpty)
                _infoCard(
                  icon: Icons.settings_outlined,
                  label: 'Piezas',
                  value: mantenimiento.piezas!,
                ),
              if (mantenimiento.taller != null &&
                  mantenimiento.taller!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoCard(
                  icon: Icons.location_city_outlined,
                  label: 'Taller',
                  value: mantenimiento.taller!,
                ),
              ],
              if (mantenimiento.observaciones != null &&
                  mantenimiento.observaciones!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _infoCard(
                  icon: Icons.description_outlined,
                  label: 'Observaciones',
                  value: mantenimiento.observaciones!,
                  isMultiline: true,
                ),
              ],

              const SizedBox(height: 24),

              // Galería de fotos
              if (mantenimiento.fotosUrls.isNotEmpty) ...[
                Text('FOTOS', style: AppTextStyles.labelMedium),
                const SizedBox(height: 12),
                PhotoGalleryWidget(
                  photoUrls: mantenimiento.fotosUrls,
                  proxyUrl: _proxyUrl,
                ),
              ],
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
              Text('Error al cargar', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
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

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelSmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
