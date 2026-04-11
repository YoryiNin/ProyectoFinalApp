import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/core/router/route_names.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../widgets/avatar_picker_widget.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).loadPerfil());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mi Perfil', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          // Botón cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content:
                      const Text('¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Cerrar sesión',
                          style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
              if (confirm == true && mounted) {
                await ref.read(authProvider.notifier).logout();
                context.go(RouteNames.dashboard);
              }
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // Avatar
                  AvatarPickerWidget(
                    fotoUrl: user.fotoUrl,
                    isLoading: authState.isLoading,
                    onImageSelected: (path) async {
                      final ok = await ref
                          .read(authProvider.notifier)
                          .updateFoto(path);
                      if (!ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ref.read(authProvider).error ??
                                'Error al actualizar foto'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(user.nombreCompleto, style: AppTextStyles.headlineSmall),
                  if (user.rol != null) ...[
                    const SizedBox(height: 4),
                    Text(user.rol!, style: AppTextStyles.bodySmall),
                  ],

                  const SizedBox(height: 32),

                  // Info card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.overlay, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                            Icons.badge_outlined, 'Matrícula', user.matricula),
                        _divider(),
                        _infoRow(Icons.person_outline, 'Nombre',
                            user.nombreCompleto),
                        if (user.correo != null) ...[
                          _divider(),
                          _infoRow(
                              Icons.email_outlined, 'Correo', user.correo!),
                        ],
                        if (user.grupo != null) ...[
                          _divider(),
                          _infoRow(Icons.group_outlined, 'Grupo', user.grupo!),
                        ],
                        if (user.rol != null) ...[
                          _divider(),
                          _infoRow(Icons.work_outline, 'Rol', user.rol!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(label,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
          const Spacer(),
          Flexible(
            child: Text(value,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(color: AppColors.overlay, thickness: 0.5, height: 0);
}
