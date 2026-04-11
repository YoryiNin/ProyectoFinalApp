import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taller_itla_app/theme/app_colors.dart';

class AvatarPickerWidget extends StatelessWidget {
  final String? fotoUrl;
  final bool isLoading;
  final void Function(String filePath) onImageSelected;

  const AvatarPickerWidget({
    super.key,
    this.fotoUrl,
    required this.onImageSelected,
    this.isLoading = false,
  });

  /// Retorna la URL proxeada correctamente, sin doble encoding.
  String _proxy(String url) {
    if (url.isEmpty) return '';
    if (url.contains('taller-itla.ia3x.com/api/imagen')) return url;
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.overlay,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading:
                const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
            title: const Text('Cámara'),
            onTap: () async {
              Navigator.pop(context);
              final file = await picker.pickImage(source: ImageSource.camera);
              if (file != null) onImageSelected(file.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined,
                color: AppColors.primary),
            title: const Text('Galería'),
            onTap: () async {
              Navigator.pop(context);
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) onImageSelected(file.path);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawUrl = fotoUrl ?? '';
    final hasPhoto = rawUrl.isNotEmpty;
    final proxiedUrl = hasPhoto ? _proxy(rawUrl) : '';

    return GestureDetector(
      onTap: isLoading ? null : () => _pickImage(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Avatar
          CircleAvatar(
            radius: 52,
            backgroundColor: AppColors.overlay,
            child: isLoading
                ? const CircularProgressIndicator(color: AppColors.primary)
                : (hasPhoto
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: proxiedUrl,
                          width: 104,
                          height: 104,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 52,
                            color: AppColors.textHint,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 52,
                        color: AppColors.textHint,
                      )),
          ),
          // Botón editar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
