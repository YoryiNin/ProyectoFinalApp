import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/vehiculo_entity.dart';

class VehiculoCard extends StatelessWidget {
  final VehiculoEntity vehiculo;
  final VoidCallback onTap;

  const VehiculoCard({
    super.key,
    required this.vehiculo,
    required this.onTap,
  });

  /// Devuelve la URL proxeada si ya no lo está, o la URL directa si es local.
  String _proxyUrl(String url) {
    if (url.isEmpty) return '';
    // Si ya contiene el proxy, no dobles
    if (url.contains('taller-itla.ia3x.com/api/imagen')) return url;
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        child: Row(
          children: [
            // Foto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehiculo.nombreCompleto,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vehiculo.displayPlaca,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chasis: ${vehiculo.chasis}',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final rawUrl = vehiculo.fotoUrl ?? '';

    if (rawUrl.isEmpty) {
      return _placeholder();
    }

    final url = _proxyUrl(rawUrl);

    return CachedNetworkImage(
      imageUrl: url,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.directions_car_outlined,
        size: 32,
        color: AppColors.textHint,
      ),
    );
  }
}
