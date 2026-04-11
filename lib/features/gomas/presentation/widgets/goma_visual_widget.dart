import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/goma_entity.dart';
import 'goma_status_badge.dart';

class GomaVisualWidget extends StatelessWidget {
  final List<GomaEntity> gomas;
  final Function(GomaEntity) onGomaTap;

  const GomaVisualWidget({
    super.key,
    required this.gomas,
    required this.onGomaTap,
  });

  GomaEntity? _findGoma(String posicion) {
    try {
      return gomas.firstWhere((g) => g.posicion == posicion);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final delanteraIzq = _findGoma('DelanteraIzq');
    final delanteroDer = _findGoma('DelanteroDer');
    final traseroIzq = _findGoma('TraseroIzq');
    final traseroDer = _findGoma('TraseroDer');

    return Column(
      children: [
        // Vista superior del auto (vista de pájaro) para 2 puertas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.overlay, width: 0.5),
          ),
          child: Column(
            children: [
              // Capó (parte delantera)
              Container(
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('MOTOR',
                      style: TextStyle(fontSize: 10, color: Colors.white70)),
                ),
              ),
              const SizedBox(height: 12),

              // Eje delantero
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child:
                          _buildGomaCard(delanteraIzq, 'Delantera\nIzquierda')),
                  const SizedBox(width: 16),
                  Expanded(
                      child:
                          _buildGomaCard(delanteroDer, 'Delantera\nDerecha')),
                ],
              ),

              // Cabina (centro del auto - 2 puertas)
              Container(
                height: 70,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SKYLINE GT-R R34',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2 PUERTAS • COUPÉ',
                        style: TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),

              // Eje trasero
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buildGomaCard(traseroIzq, 'Trasera\nIzquierda')),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildGomaCard(traseroDer, 'Trasera\nDerecha')),
                ],
              ),

              const SizedBox(height: 12),
              // Maletero
              Container(
                height: 25,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('TRUNK',
                      style: TextStyle(fontSize: 9, color: Colors.white70)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGomaCard(GomaEntity? goma, String label) {
    if (goma == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay),
        ),
        child: Column(
          children: [
            const Icon(Icons.circle_outlined,
                size: 36, color: AppColors.textHint),
            const SizedBox(height: 8),
            Text(label,
                style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Sin datos', style: AppTextStyles.labelSmall),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onGomaTap(goma),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: goma.estado.color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              Icons.circle,
              size: 36,
              color: goma.estado.color,
            ),
            const SizedBox(height: 8),
            Text(label,
                style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            GomaStatusBadge(
              estado: goma.estado,
              onTap: () => onGomaTap(goma),
            ),
            if (goma.pinchazos.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 10, color: AppColors.warning),
                  const SizedBox(width: 2),
                  Text(
                    '${goma.pinchazos.length} pinchazo(s)',
                    style: AppTextStyles.labelSmall.copyWith(fontSize: 9),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
