import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../data/models/integrante_model.dart';

class IntegranteCard extends StatelessWidget {
  final IntegranteModel integrante;

  const IntegranteCard({super.key, required this.integrante});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Column(
        children: [
          // Header con foto y nombre
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        integrante.nombre,
                        style: AppTextStyles.titleLarge
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        integrante.rol,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          integrante.matricula,
                          style: AppTextStyles.plateCode
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Links de contacto
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildContactRow(
                  icon: Icons.phone_outlined,
                  label: integrante.telefono,
                  color: AppColors.success,
                  onTap: () => _launch('tel:${integrante.telefono}'),
                ),
                const Divider(
                    color: AppColors.overlay, thickness: 0.5, height: 12),
                _buildContactRow(
                  icon: Icons.send_outlined,
                  label: '@${integrante.telegram}',
                  color: AppColors.info,
                  onTap: () => _launch('https://t.me/${integrante.telegram}'),
                ),
                const Divider(
                    color: AppColors.overlay, thickness: 0.5, height: 12),
                _buildContactRow(
                  icon: Icons.email_outlined,
                  label: integrante.correo,
                  color: AppColors.warning,
                  onTap: () => _launch('mailto:${integrante.correo}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (integrante.fotoAsset != null) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage(integrante.fotoAsset!),
        backgroundColor: AppColors.overlay,
      );
    }
    // Avatar con inicial si no hay foto
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white.withOpacity(0.2),
      child: Text(
        integrante.nombre.isNotEmpty ? integrante.nombre[0].toUpperCase() : '?',
        style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
