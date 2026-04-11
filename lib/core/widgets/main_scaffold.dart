import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/features/auth/presentation/screens/cambiar_clave_screen.dart';
import 'package:taller_itla_app/features/foro/presentation/screens/mis_temas_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/crear_tema_screen.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../router/route_names.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        context.go(RouteNames.noticias);
        break;
      case 2:
        context.go(RouteNames.videos);
        break;
      case 3:
        context.go(RouteNames.catalogo);
        break;
      case 4:
        _showMenuBottomSheet(context);
        break;
    }
  }

  void _showMenuBottomSheet(BuildContext context) {
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.isAuthenticated;

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

          // ── Opciones autenticadas ──────────────────────────
          if (isAuthenticated) ...[
            _buildMenuTile(
              icon: Icons.person_outline,
              label: 'Mi Perfil',
              onTap: () {
                Navigator.pop(context);
                context.go(RouteNames.perfil);
              },
            ),
            const Divider(color: AppColors.overlay, height: 1),
            _buildMenuTile(
              icon: Icons.directions_car_outlined,
              label: 'Mis Vehículos',
              onTap: () {
                Navigator.pop(context);
                context.go(RouteNames.misVehiculos);
              },
            ),
            const Divider(color: AppColors.overlay, height: 1),
            _buildMenuTile(
              icon: Icons.lock_outline,
              label: 'Cambiar Contraseña',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CambiarClaveScreen()),
                );
              },
            ),
            const Divider(color: AppColors.overlay, height: 1),
            _buildMenuTile(
              icon: Icons.forum_outlined,
              label: 'Mis Temas',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MisTemasScreen()),
                );
              },
            ),
            const Divider(color: AppColors.overlay, height: 1),
            _buildMenuTile(
              icon: Icons.add_circle_outline,
              label: 'Crear Tema',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CrearTemaScreen(
                            vehiculoId: '',
                          )),
                );
              },
            ),
            const Divider(color: AppColors.overlay, height: 1),
          ],

          // ── Opciones públicas ──────────────────────────────
          _buildMenuTile(
            icon: Icons.public_outlined,
            label: 'Foro Público',
            onTap: () {
              Navigator.pop(context);
              context.go(RouteNames.foro);
            },
          ),
          const Divider(color: AppColors.overlay, height: 1),

          _buildMenuTile(
            icon: Icons.info_outline,
            label: 'Acerca De',
            onTap: () {
              Navigator.pop(context);
              context.go(RouteNames.acercaDe);
            },
          ),
          const Divider(color: AppColors.overlay, height: 1),

          // ── Login / Logout ─────────────────────────────────
          if (isAuthenticated)
            _buildMenuTile(
              icon: Icons.logout,
              label: 'Cerrar Sesión',
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Cerrar Sesión',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  await ref.read(authProvider.notifier).logout();
                  if (mounted) context.go(RouteNames.dashboard);
                }
              },
            )
          else
            _buildMenuTile(
              icon: Icons.login,
              label: 'Iniciar Sesión',
              iconColor: AppColors.primary,
              textColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                context.go(RouteNames.login);
              },
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
    Color textColor = AppColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(color: textColor)),
      trailing:
          const Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}
