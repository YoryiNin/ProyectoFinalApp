import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/goma_entity.dart';

class GomaStatusBadge extends StatelessWidget {
  final GomaEstado estado;
  final VoidCallback onTap;

  const GomaStatusBadge({
    super.key,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: estado.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: estado.color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: estado.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              estado.display,
              style: AppTextStyles.labelSmall.copyWith(color: estado.color),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.edit, size: 12, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
