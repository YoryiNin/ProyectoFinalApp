import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';
import '../providers/foro_provider.dart';
import '../widgets/tema_card.dart';
import 'foro_detalle_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/crear_tema_screen.dart';

class ForoScreen extends ConsumerWidget {
  const ForoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temasAsync = ref.watch(temasListProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return MainScaffold(
      currentIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: isAuthenticated
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CrearTemaScreen(vehiculoId: ''),
                    ),
                  ).then((_) => ref.invalidate(temasListProvider));
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FORO', style: AppTextStyles.headlineMedium),
                        Text('Comunidad AutoGestor',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    temasAsync.when(
                      data: (temas) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${temas.length} temas',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Banner: solo visible si NO está autenticado
              if (!isAuthenticated)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.info.withOpacity(0.3), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 14, color: AppColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Inicia sesión para participar en el foro',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),

              if (!isAuthenticated) const SizedBox(height: 12),

              // Lista de temas
              Expanded(
                child: temasAsync.when(
                  data: (temas) {
                    if (temas.isEmpty) return _buildEmpty();
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async => ref.invalidate(temasListProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: temas.length,
                        itemBuilder: (ctx, i) => TemaCard(
                          tema: temas[i],
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ForoDetalleScreen(temaId: temas[i].id),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, _) => _buildError(ref, err),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.forum_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Sin temas publicados', style: AppTextStyles.headlineSmall),
        ],
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
            Text('Error al cargar el foro', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Verifica tu conexión e intenta de nuevo.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(temasListProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
