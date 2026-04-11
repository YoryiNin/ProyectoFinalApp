import 'package:flutter/material.dart';
import 'package:taller_itla_app/features/acerca_de/data/models/integrante_model.dart';
import 'package:taller_itla_app/features/acerca_de/presentation/widgets/integrante_card.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ACERCA DE', style: AppTextStyles.headlineMedium),
                    Text('Equipo de Desarrollo',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // App info card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.directions_car,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AutoGestor ITLA',
                              style: AppTextStyles.headlineSmall
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              'Versión 1.0.0',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Aplicación de gestión vehicular desarrollada por estudiantes del ITLA. '
                      'Controla mantenimientos, gastos, y más desde tu móvil.',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Etiqueta del equipo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'INTEGRANTES',
                  style: AppTextStyles.labelMedium.copyWith(
                    letterSpacing: 1.5,
                    color: AppColors.textHint,
                  ),
                ),
              ),

              // Cards del equipo
              ...equipoItla.map(
                (integrante) => IntegranteCard(integrante: integrante),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
