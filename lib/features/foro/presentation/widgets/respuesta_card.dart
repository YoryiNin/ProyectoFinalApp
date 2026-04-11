import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/tema_entity.dart';

class RespuestaCard extends StatelessWidget {
  final RespuestaEntity respuesta;
  final int index;

  const RespuestaCard({
    super.key,
    required this.respuesta,
    required this.index,
  });

  String _proxy(String url) =>
      'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          ClipOval(child: _buildAvatar()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(respuesta.autor, style: AppTextStyles.titleSmall),
                    const Spacer(),
                    Text(
                      '#${index + 1}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(respuesta.fecha, style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Text(respuesta.contenido, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final url = respuesta.autorFotoUrl ?? '';
    if (url.isEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.overlay,
        child: Text(
          respuesta.autor.isNotEmpty ? respuesta.autor[0].toUpperCase() : '?',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: _proxy(url),
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          const CircleAvatar(radius: 20, backgroundColor: AppColors.overlay),
      errorWidget: (_, __, ___) => CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.overlay,
        child: Text(
          respuesta.autor.isNotEmpty ? respuesta.autor[0].toUpperCase() : '?',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
