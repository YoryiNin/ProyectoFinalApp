import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/combustible_provider.dart'; // ← Asegúrate de tener este import
import '../widgets/combustible_card.dart';
import 'combustible_form_screen.dart';

class CombustibleScreen extends ConsumerStatefulWidget {
  final String vehiculoId;
  final String vehiculoNombre;

  const CombustibleScreen({
    super.key,
    required this.vehiculoId,
    required this.vehiculoNombre,
  });

  @override
  ConsumerState<CombustibleScreen> createState() => _CombustibleScreenState();
}

class _CombustibleScreenState extends ConsumerState<CombustibleScreen> {
  String _tipoFiltro = 'todos';

  @override
  Widget build(BuildContext context) {
    final registrosAsync = ref.watch(
      _tipoFiltro == 'todos'
          ? combustibleListProvider(widget.vehiculoId)
          : combustibleFiltradosProvider((widget.vehiculoId, _tipoFiltro)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Combustible - ${widget.vehiculoNombre}',
          style: AppTextStyles.titleMedium,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CombustibleFormScreen(vehiculoId: widget.vehiculoId),
                ),
              ).then((_) {
                // Invalidate both providers to refresh data
                ref.invalidate(combustibleListProvider(widget.vehiculoId));
                ref.invalidate(combustibleFiltradosProvider(
                    (widget.vehiculoId, _tipoFiltro)));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro por tipo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'todos', label: Text('Todos')),
                      ButtonSegment(
                          value: 'combustible', label: Text('⛽ Combustible')),
                      ButtonSegment(value: 'aceite', label: Text('🔧 Aceite')),
                    ],
                    selected: {_tipoFiltro},
                    onSelectionChanged: (Set<String> selection) {
                      setState(() => _tipoFiltro = selection.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: registrosAsync.when(
              data: (registros) {
                if (registros.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tipoFiltro == 'combustible'
                              ? Icons.local_gas_station_outlined
                              : Icons.build_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _tipoFiltro == 'todos'
                              ? 'Sin registros'
                              : 'Sin registros de ${_tipoFiltro == "combustible" ? "combustible" : "aceite"}',
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toca el botón + para agregar',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref.invalidate(combustibleListProvider(widget.vehiculoId));
                    ref.invalidate(combustibleFiltradosProvider(
                        (widget.vehiculoId, _tipoFiltro)));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: registros.length,
                    itemBuilder: (ctx, i) => CombustibleCard(
                      registro: registros[i],
                      onTap: () {},
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
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text('Error al cargar', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      err.toString(),
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(
                            combustibleListProvider(widget.vehiculoId));
                        ref.invalidate(combustibleFiltradosProvider(
                            (widget.vehiculoId, _tipoFiltro)));
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
