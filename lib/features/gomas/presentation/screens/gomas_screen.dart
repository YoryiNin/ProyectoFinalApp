import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/goma_entity.dart';
import '../providers/gomas_provider.dart';
import '../widgets/goma_visual_widget.dart';

class GomasScreen extends ConsumerStatefulWidget {
  final String vehiculoId;
  final String vehiculoNombre;

  const GomasScreen({
    super.key,
    required this.vehiculoId,
    required this.vehiculoNombre,
  });

  @override
  ConsumerState<GomasScreen> createState() => _GomasScreenState();
}

class _GomasScreenState extends ConsumerState<GomasScreen> {
  GomaEntity? _gomaSeleccionada;

  Future<void> _actualizarEstado(GomaEntity goma) async {
    final nuevosEstados = ['buena', 'regular', 'mala', 'reemplazada'];
    final estadoActual = goma.estado.display.toLowerCase();

    final nuevoEstado = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cambiar Estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: nuevosEstados.map((estado) {
            return RadioListTile<String>(
              title: Text(estado.toUpperCase()),
              value: estado,
              groupValue: estadoActual,
              onChanged: (value) => Navigator.pop(_, value),
            );
          }).toList(),
        ),
      ),
    );

    if (nuevoEstado != null && nuevoEstado != estadoActual && mounted) {
      final result =
          await ref.read(actualizarGomaUseCaseProvider)(goma.id, nuevoEstado);
      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.error),
          );
        },
        (_) {
          ref.invalidate(gomasListProvider(widget.vehiculoId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Estado actualizado'),
                backgroundColor: AppColors.success),
          );
        },
      );
    }
  }

  Future<void> _registrarPinchazo(GomaEntity goma) async {
    final descripcion = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Pinchazo'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Describe lo ocurrido...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(_, (_.widget as TextField).controller?.text),
            child: const Text('Registrar'),
          ),
        ],
      ),
    );

    if (descripcion != null && descripcion.isNotEmpty && mounted) {
      final result = await ref.read(registrarPinchazoUseCaseProvider)(
        goma.id,
        descripcion,
        DateTime.now(),
      );
      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.error),
          );
        },
        (_) {
          ref.invalidate(gomasListProvider(widget.vehiculoId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pinchazo registrado'),
                backgroundColor: AppColors.success),
          );
        },
      );
    }
  }

  void _mostrarOpcionesGoma(GomaEntity goma) {
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
          ListTile(
            leading: const Icon(Icons.edit, color: AppColors.primary),
            title: const Text('Cambiar estado'),
            onTap: () {
              Navigator.pop(_);
              _actualizarEstado(goma);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded,
                color: AppColors.warning),
            title: const Text('Registrar pinchazo'),
            onTap: () {
              Navigator.pop(_);
              _registrarPinchazo(goma);
            },
          ),
          if (goma.pinchazos.isEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sin pinchazos registrados',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ] else ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PINCHAZOS REGISTRADOS',
                      style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  ...goma.pinchazos.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                size: 12, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${p.fechaFormatted}: ${p.descripcion}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gomasAsync = ref.watch(gomasListProvider(widget.vehiculoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Estado de Gomas - ${widget.vehiculoNombre}',
            style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: gomasAsync.when(
        data: (gomas) {
          if (gomas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grass_outlined,
                      size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text('No hay datos de gomas',
                      style: AppTextStyles.headlineSmall),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GomaVisualWidget(
                  gomas: gomas,
                  onGomaTap: _mostrarOpcionesGoma,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: AppColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Toca cualquier goma para cambiar su estado o registrar un pinchazo.',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error al cargar', style: AppTextStyles.headlineSmall),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(gomasListProvider(widget.vehiculoId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
