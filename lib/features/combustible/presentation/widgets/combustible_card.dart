import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/combustible_entity.dart';

class CombustibleCard extends StatelessWidget {
  final CombustibleEntity registro;
  final VoidCallback onTap;

  const CombustibleCard({
    super.key,
    required this.registro,
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
            // Icono según tipo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: registro.tipo == 'combustible'
                    ? AppColors.warning.withOpacity(0.12)
                    : AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  registro.tipo == 'combustible' ? '⛽' : '🔧',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    registro.displayTipo,
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${registro.cantidad.toStringAsFixed(2)} ${registro.displayUnidad}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            // Monto
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  registro.montoFormatted,
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  registro.fechaFormatted,
                  style: AppTextStyles.bodySmall,
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
