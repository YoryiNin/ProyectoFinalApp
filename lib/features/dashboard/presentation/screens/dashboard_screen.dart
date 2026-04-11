import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/core/router/route_names.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/features/dashboard/presentation/motivational_banner.dart';
import 'package:taller_itla_app/features/dashboard/presentation/quick_access_grid.dart';
import 'package:taller_itla_app/features/dashboard/presentation/screens/selected_vehicle_provider.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../core/widgets/main_scaffold.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final List<Color> sliderColors = const [
    Color(0xFFFF4500),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFFFBBF24),
    Color(0xFFEF4444),
  ];

  final List<String> sliderTitles = const [
    'RENDIMIENTO',
    'SEGURIDAD',
    'TECNOLOGÍA',
    'AHORRO',
    'POTENCIA',
  ];

  final List<String> sliderSubtitles = const [
    'Optimiza tu combustible',
    'Conduce con confianza',
    'Conecta tu vehículo',
    'Reduce costos',
    'Siente la adrenalina',
  ];

  final List<String> motivationalMessages = const [
    '🔧 Un auto bien mantenido es un auto seguro.',
    '⛽ Revisa el aceite cada mes para alargar la vida del motor.',
    '🛞 La presión correcta de las gomas ahorra combustible.',
    '📅 Lleva un registro de tus mantenimientos para evitar sorpresas.',
    '🔋 Una batería en buen estado evita quedarte varado.',
  ];

  final List<Map<String, dynamic>> quickAccessItems = const [
    {
      'icon': Icons.directions_car,
      'label': 'Mis\nVehículos',
      'route': RouteNames.misVehiculos,
      'needsVehicle': false,
    },
    {
      'icon': Icons.build,
      'label': 'Mantenimientos',
      'route': RouteNames.mantenimientos,
      'needsVehicle': true,
    },
    {
      'icon': Icons.local_gas_station,
      'label': 'Combustible',
      'route': RouteNames.combustible,
      'needsVehicle': true,
    },
    {
      'icon': Icons.grass,
      'label': 'Gomas',
      'route': RouteNames.gomas,
      'needsVehicle': true,
    },
    {
      'icon': Icons.attach_money,
      'label': 'Gastos /\nIngresos',
      'route': RouteNames.gastosIngresos,
      'needsVehicle': true,
    },
    {
      'icon': Icons.forum,
      'label': 'Foro',
      'route': RouteNames.foro,
      'needsVehicle': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < sliderColors.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onQuickAccessTap(
      BuildContext context, String route, bool needsVehicle) {
    final isAuth = ref.read(authProvider).isAuthenticated;

    // Rutas públicas sin necesidad de vehículo
    if (!needsVehicle) {
      context.go(route);
      return;
    }

    // Requiere estar autenticado
    if (!isAuth) {
      _showLoginRequired(context);
      return;
    }

    // Requiere vehículo seleccionado
    final selectedVehicle = ref.read(selectedVehicleProvider);
    if (selectedVehicle == null) {
      _showVehicleSelector(context, route);
    } else {
      // Ya hay vehículo seleccionado → navegar directo con el ID
      context.go('$route?vehiculoId=${selectedVehicle.id}');
    }
  }

  void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Inicia sesión'),
        content:
            const Text('Necesitas una cuenta para acceder a esta sección.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.login);
            },
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }

  void _showVehicleSelector(BuildContext context, String destinationRoute) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.overlay,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_car_outlined,
                      color: AppColors.warning, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sin vehículo seleccionado',
                          style: AppTextStyles.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        'Selecciona un vehículo para continuar',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions_car),
                label: const Text('Ir a Mis Vehículos'),
                onPressed: () {
                  Navigator.pop(context);
                  context.go(RouteNames.misVehiculos);
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedVehicle = ref.watch(selectedVehicleProvider);
    final isAuth = ref.watch(authProvider).isAuthenticated;

    return MainScaffold(
      currentIndex: 0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            _buildColorSlider(),
            _buildPageIndicator(),

            // Banner de vehículo seleccionado (si aplica)
            if (isAuth) ...[
              const SizedBox(height: 16),
              _buildSelectedVehicleBanner(context, selectedVehicle),
            ],

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ACCESO RÁPIDO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 12),

            QuickAccessGrid(
              items: quickAccessItems.map((item) {
                return {
                  ...item,
                  'onTap': () => _onQuickAccessTap(
                        context,
                        item['route'] as String,
                        item['needsVehicle'] as bool,
                      ),
                };
              }).toList(),
            ),

            const SizedBox(height: 24),

            MotivationalBanner(messages: motivationalMessages),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedVehicleBanner(
      BuildContext context, SelectedVehicle? vehicle) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.misVehiculos),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: vehicle != null
              ? AppColors.success.withOpacity(0.1)
              : AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: vehicle != null
                ? AppColors.success.withOpacity(0.3)
                : AppColors.warning.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              vehicle != null
                  ? Icons.check_circle_outline
                  : Icons.directions_car_outlined,
              size: 16,
              color: vehicle != null ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                vehicle != null
                    ? 'Vehículo activo: ${vehicle.nombre}'
                    : 'Toca aquí para seleccionar un vehículo',
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      vehicle != null ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: vehicle != null ? AppColors.success : AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSlider() {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: sliderColors.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  sliderColors[index],
                  sliderColors[index].withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getIconForIndex(index),
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sliderTitles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sliderSubtitles[index],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          sliderColors.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index
                  ? const Color(0xFFFF4500)
                  : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    const icons = [
      Icons.speed,
      Icons.security,
      Icons.bluetooth,
      Icons.savings,
      Icons.bolt,
    ];
    return icons[index % icons.length];
  }
}
