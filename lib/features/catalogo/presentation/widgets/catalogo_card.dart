import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/catalogo_vehiculo_entity.dart';

class CatalogoCard extends StatelessWidget {
  final CatalogoVehiculoEntity vehiculo;
  final VoidCallback onTap;

  const CatalogoCard({
    super.key,
    required this.vehiculo,
    required this.onTap,
  });

  String get _proxyUrl {
    if (vehiculo.imagenUrl.isEmpty) return '';
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(vehiculo.imagenUrl)}';
  }

  String get _precioFormateado {
    if (vehiculo.precio <= 0) return 'Precio a consultar';
    final precio = vehiculo.precio.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'RD\$ $precio';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImagen(),
                  // Badge condición
                  if (vehiculo.condicion != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildBadge(vehiculo.condicion!),
                    ),
                  // Overlay gradiente abajo
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: AppColors.heroGradient,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehiculo.marca} ${vehiculo.modelo}',
                      style: AppTextStyles.titleSmall.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${vehiculo.anio}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      _precioFormateado,
                      style: AppTextStyles.priceSmall,
                      maxLines: 1,
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

  Widget _buildImagen() {
    if (_proxyUrl.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.directions_car_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: _proxyUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.directions_car_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
