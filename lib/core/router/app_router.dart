import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/features/acerca_de/screens/acerca_de_screen.dart';
import 'package:taller_itla_app/features/auth/presentation/screens/login_screen.dart';
import 'package:taller_itla_app/features/auth/presentation/screens/perfil_screen.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/features/catalogo/presentation/screens/catalogo_screen.dart';
import 'package:taller_itla_app/features/combustible/presentation/screens/combustible_screen.dart';
import 'package:taller_itla_app/features/foro/presentation/screens/foro_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/gastos_screen.dart';
import 'package:taller_itla_app/features/gastos_ingresos/presentation/screens/ingresos_screen.dart';
import 'package:taller_itla_app/features/gomas/presentation/screens/gomas_screen.dart';
import 'package:taller_itla_app/features/mantenimientos/presentation/screens/mantenimientos_screen.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/screens/vehiculos_screen.dart';
import 'package:taller_itla_app/features/videos/screens/video_player_screen.dart';
import 'package:taller_itla_app/features/videos/screens/videos_screen.dart';
import 'route_names.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/noticias/presentation/screens/noticias_screen.dart';
import '../../features/noticias/presentation/screens/noticia_detalle_screen.dart';

// Rutas que requieren auth
const _rutasProtegidas = [
  RouteNames.perfil,
  RouteNames.misVehiculos,
  RouteNames.mantenimientos,
  RouteNames.combustible,
  RouteNames.gomas,
  RouteNames.gastosIngresos,
];

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(ProviderContainer container) {
    return GoRouter(
      // Siempre arranca en login; el redirect redirige si ya hay sesión
      initialLocation: RouteNames.login,
      redirect: (context, state) {
        final authState = container.read(authProvider);
        final isAuth = authState.isAuthenticated;
        final path = state.matchedLocation;

        // Si ya está autenticado y va al login → dashboard
        if (isAuth && path == RouteNames.login) {
          return RouteNames.dashboard;
        }

        // Si la ruta requiere auth y no está autenticado → login
        if (!isAuth && _rutasProtegidas.contains(path)) {
          return RouteNames.login;
        }

        return null;
      },
      routes: [
        // Rutas públicas
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: RouteNames.noticias,
          name: RouteNames.noticias,
          builder: (context, state) => const NoticiasScreen(),
        ),
        GoRoute(
          path: RouteNames.noticiaDetalle,
          name: RouteNames.noticiaDetalle,
          builder: (context, state) {
            final id = state.uri.queryParameters['id'] ?? '';
            final titulo = state.uri.queryParameters['titulo'] ?? '';
            final contenidoHtml =
                state.uri.queryParameters['contenidoHtml'] ?? '';
            return NoticiaDetalleScreen(
              id: id,
              titulo: titulo,
              contenidoHtml: contenidoHtml,
            );
          },
        ),
        GoRoute(
          path: RouteNames.videos,
          name: RouteNames.videos,
          builder: (context, state) => const VideosScreen(),
        ),
        GoRoute(
          path: RouteNames.videoPlayer,
          name: RouteNames.videoPlayer,
          builder: (context, state) {
            final youtubeId = state.uri.queryParameters['youtubeId'] ?? '';
            final titulo = state.uri.queryParameters['titulo'] ?? '';
            return VideoPlayerScreen(
              youtubeId: youtubeId,
              titulo: titulo,
            );
          },
        ),
        GoRoute(
          path: RouteNames.catalogo,
          name: RouteNames.catalogo,
          builder: (context, state) => const CatalogoScreen(),
        ),
        GoRoute(
          path: RouteNames.foro,
          name: RouteNames.foro,
          builder: (context, state) => const ForoScreen(),
        ),
        GoRoute(
          path: RouteNames.acercaDe,
          name: RouteNames.acercaDe,
          builder: (context, state) => const AcercaDeScreen(),
        ),

        // Rutas protegidas
        GoRoute(
          path: RouteNames.perfil,
          name: RouteNames.perfil,
          builder: (context, state) => const PerfilScreen(),
        ),
        GoRoute(
          path: RouteNames.misVehiculos,
          name: RouteNames.misVehiculos,
          builder: (context, state) => const VehiculosScreen(),
        ),
        GoRoute(
          path: RouteNames.mantenimientos,
          name: RouteNames.mantenimientos,
          builder: (context, state) {
            final vehiculoId = state.uri.queryParameters['vehiculoId'] ?? '';
            return MantenimientosScreen(
              vehiculoId: vehiculoId,
              vehiculoNombre: '',
            );
          },
        ),
        GoRoute(
          path: RouteNames.combustible,
          name: RouteNames.combustible,
          builder: (context, state) {
            final vehiculoId = state.uri.queryParameters['vehiculoId'] ?? '';
            return CombustibleScreen(
              vehiculoId: vehiculoId,
              vehiculoNombre: '',
            );
          },
        ),
        GoRoute(
          path: RouteNames.gomas,
          name: RouteNames.gomas,
          builder: (context, state) {
            final vehiculoId = state.uri.queryParameters['vehiculoId'] ?? '';
            return GomasScreen(
              vehiculoId: vehiculoId,
              vehiculoNombre: '',
            );
          },
        ),
        GoRoute(
          path: RouteNames.gastosIngresos,
          name: RouteNames.gastosIngresos,
          builder: (context, state) {
            final vehiculoId = state.uri.queryParameters['vehiculoId'] ?? '';
            return GastosScreen(
              vehiculoId: vehiculoId,
              vehiculoNombre: '',
            );
          },
        ),
      ],
    );
  }
}
