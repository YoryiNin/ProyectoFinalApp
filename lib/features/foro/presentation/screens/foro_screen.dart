import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/features/foro/presentation/screens/CrearTemaScreen.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';
import '../providers/foro_provider.dart';
import '../widgets/tema_card.dart';
import 'foro_detalle_screen.dart';

class ForoScreen extends ConsumerWidget {
  const ForoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temasAsync = ref.watch(temasListProvider);
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    final vehiculoId = authState.user?.vehiculoId ?? '';

    return MainScaffold(
      currentIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: isAuthenticated
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón de debug (solo para pruebas)
                  FloatingActionButton(
                    heroTag: 'debug',
                    mini: true,
                    backgroundColor: Colors.grey[800],
                    onPressed: () {
                      _showDebugInfo(context, ref);
                    },
                    child: const Icon(Icons.bug_report, size: 20),
                  ),
                  const SizedBox(height: 8),
                  // Botón normal de crear tema
                  FloatingActionButton(
                    heroTag: 'crear',
                    onPressed: () {
                      if (vehiculoId.isEmpty) {
                        _showNoVehicleDialog(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CrearTemaScreen(
                              vehiculoId: vehiculoId,
                            ),
                          ),
                        ).then((result) {
                          if (result == true) {
                            // Recargar listas después de crear un tema
                            ref.invalidate(temasListProvider);
                            ref.invalidate(misTemasProvider);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Tema creado exitosamente!'),
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FORO', style: AppTextStyles.headlineMedium),
                        const SizedBox(height: 4),
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

              // Banner de autenticación
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

              if (!isAuthenticated) const SizedBox(height: 8),

              // Botón de recarga
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppColors.primary, size: 20),
                      onPressed: () {
                        ref.invalidate(temasListProvider);
                        ref.invalidate(misTemasProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recargando foro...'),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      },
                      tooltip: 'Recargar foro',
                    ),
                  ],
                ),
              ),

              // Lista de temas
              Expanded(
                child: temasAsync.when(
                  data: (temas) {
                    if (temas.isEmpty) return _buildEmpty();
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        ref.invalidate(temasListProvider);
                        ref.invalidate(misTemasProvider);
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
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
                          ).then((_) {
                            ref.invalidate(temasListProvider);
                          }),
                        ),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, stack) => _buildError(ref, err),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDebugInfo(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authProvider);
    final user = authState.user;

    // Calcular longitud del token de forma segura
    final tokenLength = user?.token?.length ?? 0;
    final tokenPreview = user?.token != null && tokenLength > 0
        ? '${user!.token!.substring(0, tokenLength > 20 ? 20 : tokenLength)}...'
        : 'No token';

    print('╔════════════════════════════════════════════════════════════╗');
    print('║ 🔍 DEBUG - INFORMACIÓN DEL USUARIO');
    print('╠════════════════════════════════════════════════════════════╣');
    print('║ 📱 ID: ${user?.id}');
    print('║ 👤 Nombre: ${user?.nombre} ${user?.apellido}');
    print('║ 📧 Email: ${user?.correo}');
    print('║ 🚗 Vehículo ID: ${user?.vehiculoId ?? "NULL"}');
    print('║ 🔑 Token: $tokenPreview');
    print('║ ✅ Autenticado: ${authState.isAuthenticated}');
    print('╚════════════════════════════════════════════════════════════╝');

    // Mostrar diálogo con la información
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Información de Debug'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDebugRow('ID', user?.id ?? 'No disponible'),
            _buildDebugRow('Nombre', user?.nombre ?? 'No disponible'),
            _buildDebugRow('Apellido', user?.apellido ?? 'No disponible'),
            _buildDebugRow('Vehículo ID', user?.vehiculoId ?? 'NULL ⚠️'),
            _buildDebugRow(
                'Autenticado', authState.isAuthenticated ? 'Sí' : 'No'),
            const SizedBox(height: 16),
            if (user?.vehiculoId == null || (user?.vehiculoId?.isEmpty ?? true))
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.error, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ No tienes un vehículo asociado. No podrás crear temas.',
                        style: TextStyle(fontSize: 12, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoVehicleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sin vehículo registrado'),
        content: const Text(
          'Para crear un tema en el foro, primero debes tener un vehículo registrado en tu cuenta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
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
          const SizedBox(height: 8),
          Text(
            'Sé el primero en crear un tema',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          ),
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
              onPressed: () {
                ref.invalidate(temasListProvider);
                ref.invalidate(misTemasProvider);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
