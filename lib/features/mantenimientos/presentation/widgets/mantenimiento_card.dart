import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/mantenimiento_entity.dart';

class MantenimientoCard extends StatelessWidget {
  final MantenimientoEntity mantenimiento;
  final VoidCallback onTap;

  const MantenimientoCard({
    super.key,
    required this.mantenimiento,
    required this.onTap,
  });

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
          children: [
            // Ícono del tipo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(mantenimiento.tipoIcon,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mantenimiento.tipo,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mantenimiento.fechaFormatted,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            // Costo
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  mantenimiento.costoFormatted,
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.primary),
                ),
                if (mantenimiento.fotosUrls.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.image,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Text(
                        '${mantenimiento.fotosUrls.length}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
