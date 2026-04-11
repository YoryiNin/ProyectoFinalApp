import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class MisTemasScreen extends ConsumerWidget {
  const MisTemasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mis Temas', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('Aquí aparecerán tus temas',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('Cuando participes en el foro',
                style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
