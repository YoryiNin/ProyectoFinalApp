import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/providers/vehiculos_provider.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/screens/vehiculo_detalle_screen.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/screens/vehiculo_form_screen.dart';
import 'package:taller_itla_app/features/vehiculos/presentation/widgets/vehiculo_card.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';
import '../providers/catalogo_provider.dart';
import '../widgets/catalogo_card.dart';
import '../widgets/search_filters_widget.dart';
import 'catalogo_detalle_screen.dart';

class CatalogoScreen extends ConsumerStatefulWidget {
  const CatalogoScreen({super.key});

  @override
  ConsumerState<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends ConsumerState<CatalogoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;
    final catalogoAsync = ref.watch(catalogoListProvider);

    return MainScaffold(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: isAuthenticated && _tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehiculoFormScreen(),
                    ),
                  ).then((_) => ref.invalidate(vehiculosListProvider));
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
                        Text('CATÁLOGO', style: AppTextStyles.headlineMedium),
                        Text(
                          'Encuentra tu próximo vehículo',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (_tabController.index == 0)
                      catalogoAsync.when(
                        data: (lista) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${lista.length} vehículos',
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

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Catálogo'),
                    Tab(text: 'Mis Vehículos'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ── TAB 1: Catálogo público ────────────────────────────
                    _buildCatalogoTab(catalogoAsync),

                    // ── TAB 2: Mis Vehículos ───────────────────────────────
                    isAuthenticated
                        ? _buildMisVehiculosTab()
                        : _buildLoginRequired(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogoTab(AsyncValue catalogoAsync) {
    return Column(
      children: [
        // Filtros (solo en catálogo)
        const SearchFiltersWidget(),
        const SizedBox(height: 8),

        Expanded(
          child: catalogoAsync.when(
            data: (vehiculos) {
              if (vehiculos.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  ref.invalidate(catalogoListProvider);
                },
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: vehiculos.length,
                  itemBuilder: (context, index) {
                    final vehiculo = vehiculos[index];
                    return CatalogoCard(
                      vehiculo: vehiculo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CatalogoDetalleScreen(
                              id: vehiculo.id,
                              vehiculoPreview: vehiculo,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
            loading: () => _buildLoadingGrid(),
            error: (error, _) => _buildError(error),
          ),
        ),
      ],
    );
  }

  Widget _buildMisVehiculosTab() {
    final vehiculosAsync = ref.watch(vehiculosListProvider);

    return vehiculosAsync.when(
      data: (vehiculos) {
        if (vehiculos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car_outlined,
                    size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text('No tienes vehículos registrados',
                    style: AppTextStyles.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Toca el botón + para agregar tu primer vehículo',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(vehiculosListProvider),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: vehiculos.length,
            itemBuilder: (ctx, i) => VehiculoCard(
              vehiculo: vehiculos[i],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehiculoDetalleScreen(
                      vehiculoId: vehiculos[i].id,
                    ),
                  ),
                ).then((_) => ref.invalidate(vehiculosListProvider));
              },
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Error al cargar vehículos',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(vehiculosListProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRequired() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text('Inicia sesión', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Necesitas una cuenta para ver tus vehículos registrados.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car_outlined,
              size: 72, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Sin resultados', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Prueba ajustando los filtros\nde búsqueda.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(catalogoFiltrosProvider.notifier).limpiarFiltros();
              ref.invalidate(catalogoListProvider);
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Ver todos'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 40, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text('Sin conexión', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'No se pudo cargar el catálogo.\nVerifica tu conexión e intenta de nuevo.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(catalogoListProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Color.lerp(
            AppColors.surfaceVariant,
            AppColors.overlay,
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
