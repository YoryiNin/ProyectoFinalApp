import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/foro/domain/entities/tema_entity.dart';
import 'package:taller_itla_app/features/foro/presentation/screens/foro_detalle_screen.dart';
import 'package:taller_itla_app/features/foro/presentation/widgets/tema_card.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/foro_provider.dart';

class MisTemasScreen extends ConsumerWidget {
  const MisTemasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misTemasAsync = ref.watch(misTemasProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mis Temas', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () => ref.invalidate(misTemasProvider),
          ),
        ],
      ),
      body: misTemasAsync.when(
        data: (temas) {
          if (temas.isEmpty) return _buildEmpty();
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.invalidate(misTemasProvider),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: temas.length,
              itemBuilder: (ctx, i) => _buildTemaItem(ctx, temas[i]),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => _buildError(ref, err),
      ),
    );
  }

  Widget _buildTemaItem(BuildContext context, TemaEntity tema) {
    return TemaCard(
      tema: tema,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForoDetalleScreen(temaId: tema.id),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.forum_outlined,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aún no has publicado temas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando publiques en el foro, tus temas aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(WidgetRef ref, Object err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar tus temas',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifica tu conexión e intenta de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textHint),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(misTemasProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
