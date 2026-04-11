import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/resumen_financiero_entity.dart';

class ResumenFinancieroWidget extends StatelessWidget {
  final ResumenFinancieroEntity resumen;
  final bool isLoading;

  const ResumenFinancieroWidget({
    super.key,
    required this.resumen,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer();
    }

    return Column(
      children: [
        _buildCard(
          title: 'MANTENIMIENTOS',
          value: resumen.totalMantenimientosFormatted,
          color: AppColors.info,
          icon: Icons.build_outlined,
        ),
        const SizedBox(height: 12),
        _buildCard(
          title: 'COMBUSTIBLE',
          value: resumen.totalCombustibleFormatted,
          color: AppColors.warning,
          icon: Icons.local_gas_station_outlined,
        ),
        const SizedBox(height: 12),
        _buildCard(
          title: 'GASTOS',
          value: resumen.totalGastosFormatted,
          color: AppColors.error,
          icon: Icons.trending_down_outlined,
        ),
        const SizedBox(height: 12),
        _buildCard(
          title: 'INGRESOS',
          value: resumen.totalIngresosFormatted,
          color: AppColors.success,
          icon: Icons.trending_up_outlined,
        ),
        const SizedBox(height: 12),
        _buildCard(
          title: 'BALANCE',
          value: resumen.balanceFormatted,
          color: resumen.balance >= 0 ? AppColors.success : AppColors.error,
          icon: Icons.account_balance_wallet_outlined,
          isHighlight: true,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? color : AppColors.overlay,
          width: isHighlight ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelSmall),
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isHighlight ? color : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
