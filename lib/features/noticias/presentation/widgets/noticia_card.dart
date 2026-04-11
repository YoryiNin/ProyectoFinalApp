import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../noticias/domain/entities/noticia_entity.dart';

class NoticiaCard extends StatelessWidget {
  final NoticiaEntity noticia;
  final VoidCallback onTap;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onTap,
  });

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';
    // Si la URL ya es completa, usarla directamente
    if (url.startsWith('http')) {
      return url;
    }
    // Si no, usar el proxy
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = _getImageUrl(noticia.imagenUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: imagenUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imagenUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.surfaceVariant,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                color: AppColors.error, size: 32),
                            SizedBox(height: 4),
                            Text('Sin imagen', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppColors.surfaceVariant,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.newspaper,
                              color: AppColors.textHint, size: 32),
                          SizedBox(height: 4),
                          Text('Sin imagen', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia.titulo,
                      style: AppTextStyles.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      noticia.fecha,
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticia.extracto,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
