import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/mantenimientos_provider.dart';
import '../widgets/mantenimiento_card.dart';
import 'mantenimiento_form_screen.dart';
import 'mantenimiento_detalle_screen.dart';

class MantenimientosScreen extends ConsumerStatefulWidget {
  final String vehiculoId;
  final String vehiculoNombre;

  const MantenimientosScreen({
    super.key,
    required this.vehiculoId,
    required this.vehiculoNombre,
  });

  @override
  ConsumerState<MantenimientosScreen> createState() =>
      _MantenimientosScreenState();
}

class _MantenimientosScreenState extends ConsumerState<MantenimientosScreen> {
  String? _tipoFiltro;
  final List<String> _tiposDisponibles = [
    'Todos',
    'Cambio de aceite',
    'Frenos',
    'Llantas',
    'Motor',
    'Eléctrico',
    'Suspensión',
    'Transmisión',
    'Aire acondicionado',
    'Otro',
  ];

  @override
  Widget build(BuildContext context) {
    final mantenimientosAsync = ref.watch(
      _tipoFiltro == null || _tipoFiltro == 'Todos'
          ? mantenimientosListProvider(widget.vehiculoId)
          : mantenimientosFiltradosProvider((widget.vehiculoId, _tipoFiltro!)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Mantenimientos - ${widget.vehiculoNombre}',
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
                      MantenimientoFormScreen(vehiculoId: widget.vehiculoId),
                ),
              ).then((_) {
                // Invalidar ambos providers después de crear un nuevo mantenimiento
                ref.invalidate(mantenimientosListProvider(widget.vehiculoId));
                if (_tipoFiltro != null && _tipoFiltro != 'Todos') {
                  ref.invalidate(mantenimientosFiltradosProvider(
                      (widget.vehiculoId, _tipoFiltro!)));
                }
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
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tiposDisponibles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tipo = _tiposDisponibles[index];
                  final isSelected = (_tipoFiltro == tipo) ||
                      (_tipoFiltro == null && tipo == 'Todos');
                  return FilterChip(
                    label: Text(tipo),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _tipoFiltro = tipo == 'Todos' ? null : tipo;
                      });
                      // Invalidar ambos providers al cambiar el filtro
                      ref.invalidate(
                          mantenimientosListProvider(widget.vehiculoId));
                      if (_tipoFiltro != null && _tipoFiltro != 'Todos') {
                        ref.invalidate(mantenimientosFiltradosProvider(
                            (widget.vehiculoId, _tipoFiltro!)));
                      }
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: mantenimientosAsync.when(
              data: (mantenimientos) {
                if (mantenimientos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.build_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text(
                          'Sin mantenimientos registrados',
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toca el botón + para agregar uno',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    // Recargar datos según el filtro actual
                    if (_tipoFiltro == null || _tipoFiltro == 'Todos') {
                      ref.invalidate(
                          mantenimientosListProvider(widget.vehiculoId));
                    } else {
                      ref.invalidate(mantenimientosFiltradosProvider(
                          (widget.vehiculoId, _tipoFiltro!)));
                    }
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: mantenimientos.length,
                    itemBuilder: (ctx, i) => MantenimientoCard(
                      mantenimiento: mantenimientos[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MantenimientoDetalleScreen(
                              mantenimientoId: mantenimientos[i].id,
                            ),
                          ),
                        ).then((_) {
                          // Recargar datos al volver del detalle (por si se agregaron fotos)
                          if (_tipoFiltro == null || _tipoFiltro == 'Todos') {
                            ref.invalidate(
                                mantenimientosListProvider(widget.vehiculoId));
                          } else {
                            ref.invalidate(mantenimientosFiltradosProvider(
                                (widget.vehiculoId, _tipoFiltro!)));
                          }
                        });
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
                        if (_tipoFiltro == null || _tipoFiltro == 'Todos') {
                          ref.invalidate(
                              mantenimientosListProvider(widget.vehiculoId));
                        } else {
                          ref.invalidate(mantenimientosFiltradosProvider(
                              (widget.vehiculoId, _tipoFiltro!)));
                        }
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
