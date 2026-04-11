import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class NoticiaDetalleScreen extends StatelessWidget {
  final String id;
  final String titulo;
  final String contenidoHtml;
  final String? imagenUrl;

  const NoticiaDetalleScreen({
    super.key,
    required this.id,
    required this.titulo,
    required this.contenidoHtml,
    this.imagenUrl,
  });

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http')) {
      return url;
    }
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  // Limpiar HTML para mostrar texto plano
  String get _cleanText {
    if (contenidoHtml.isEmpty) return 'No hay contenido disponible.';
    return contenidoHtml
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&aacute;', 'á')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&iacute;', 'í')
        .replaceAll('&oacute;', 'ó')
        .replaceAll('&uacute;', 'ú')
        .replaceAll('&ntilde;', 'ñ')
        .replaceAll('&Ntilde;', 'Ñ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          titulo,
          style: AppTextStyles.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen destacada si existe
            if (imagenUrl != null && imagenUrl!.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: _getImageUrl(imagenUrl!),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
              ),

            // Título
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _cleanText,
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
