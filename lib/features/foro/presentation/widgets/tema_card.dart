import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/tema_entity.dart';

class TemaCard extends StatelessWidget {
  final TemaEntity tema;
  final VoidCallback onTap;

  const TemaCard({super.key, required this.tema, required this.onTap});

  String _proxy(String url) =>
      'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto del vehículo o avatar del autor
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildThumbnail(),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tema.titulo,
                    style: AppTextStyles.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tema.autor,
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (tema.vehiculo != null && tema.vehiculo!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.directions_car_outlined,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tema.vehiculo!,
                            style: AppTextStyles.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                size: 10, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${tema.cantidadRespuestas} respuestas',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(tema.fecha, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final url = tema.vehiculoFotoUrl ?? tema.autorFotoUrl ?? '';
    if (url.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.directions_car_outlined,
            color: AppColors.textHint, size: 28),
      );
    }
    return CachedNetworkImage(
      imageUrl: _proxy(url),
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Container(width: 64, height: 64, color: AppColors.surfaceVariant),
      errorWidget: (_, __, ___) => Container(
        width: 64,
        height: 64,
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.directions_car_outlined,
            color: AppColors.textHint, size: 28),
      ),
    );
  }
}
