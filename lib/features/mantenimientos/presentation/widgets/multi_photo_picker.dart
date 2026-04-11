import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class MultiPhotoPicker extends StatefulWidget {
  final List<File> selectedPhotos;
  final Function(List<File>) onPhotosChanged;
  final int maxPhotos;

  const MultiPhotoPicker({
    super.key,
    required this.selectedPhotos,
    required this.onPhotosChanged,
    this.maxPhotos = 5,
  });

  @override
  State<MultiPhotoPicker> createState() => _MultiPhotoPickerState();
}

class _MultiPhotoPickerState extends State<MultiPhotoPicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (widget.selectedPhotos.length >= widget.maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Máximo ${widget.maxPhotos} fotos'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final file = await _picker.pickImage(source: source);
    if (file != null) {
      final newList = List<File>.from(widget.selectedPhotos)
        ..add(File(file.path));
      widget.onPhotosChanged(newList);
    }
  }

  void _removePhoto(int index) {
    final newList = List<File>.from(widget.selectedPhotos)..removeAt(index);
    widget.onPhotosChanged(newList);
  }

  void _showPickerOptions() {
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
            title: const Text('Tomar foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined,
                color: AppColors.primary),
            title: const Text('Elegir de galería'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('FOTOS', style: AppTextStyles.labelMedium),
            const SizedBox(width: 8),
            Text(
              '(${widget.selectedPhotos.length}/${widget.maxPhotos})',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.selectedPhotos.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == widget.selectedPhotos.length) {
                return _buildAddButton();
              }
              return _buildPhotoItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.overlay, width: 0.5),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 32, color: AppColors.primary),
            SizedBox(height: 4),
            Text('Agregar foto', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem(int index) {
    final file = widget.selectedPhotos[index];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            file,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
