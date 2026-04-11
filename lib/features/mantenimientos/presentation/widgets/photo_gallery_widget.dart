import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class PhotoGalleryWidget extends StatefulWidget {
  final List<String> photoUrls;
  final String Function(String)? proxyUrl; // Cambiado: String? → String

  const PhotoGalleryWidget({
    super.key,
    required this.photoUrls,
    this.proxyUrl,
  });

  @override
  State<PhotoGalleryWidget> createState() => _PhotoGalleryWidgetState();
}

class _PhotoGalleryWidgetState extends State<PhotoGalleryWidget> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getImageUrl(String url) {
    // Si hay un proxyUrl, usarlo (ahora es String Function(String), no nullable)
    if (widget.proxyUrl != null) {
      return widget.proxyUrl!(url);
    }
    if (url.isEmpty) return '';
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photoUrls.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 48, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('Sin fotos', style: TextStyle(color: AppColors.textHint)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Galería principal
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.photoUrls.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) {
                  final url = _getImageUrl(widget.photoUrls[i]);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  );
                },
              ),
              // Indicador
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.photoUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Miniaturas
        if (widget.photoUrls.length > 1)
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.photoUrls.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final url = _getImageUrl(widget.photoUrls[i]);
                final isSelected = _currentIndex == i;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.overlay,
                        width: isSelected ? 2 : 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: AppColors.surfaceVariant),
                        errorWidget: (_, __, ___) =>
                            Container(color: AppColors.surfaceVariant),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
