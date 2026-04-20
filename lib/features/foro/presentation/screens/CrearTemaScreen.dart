import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/foro_provider.dart';

class CrearTemaScreen extends ConsumerStatefulWidget {
  final String vehiculoId;

  const CrearTemaScreen({super.key, required this.vehiculoId});

  @override
  ConsumerState<CrearTemaScreen> createState() => _CrearTemaScreenState();
}

class _CrearTemaScreenState extends ConsumerState<CrearTemaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validación mejorada
    if (widget.vehiculoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró un vehículo asociado a tu cuenta.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final titulo = _tituloCtrl.text.trim();
    final descripcion = _descripcionCtrl.text.trim();

    print('📝 Creando tema con:');
    print('  - vehiculoId: ${widget.vehiculoId}');
    print('  - titulo: $titulo');
    print('  - descripcion: $descripcion');

    final result = await ref.read(crearTemaUseCaseProvider).call(
          widget.vehiculoId,
          titulo,
          descripcion,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (error) {
        print('❌ Error al crear tema: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      (tema) {
        print('✅ Tema creado exitosamente:');
        print('  - ID: ${tema.id}');
        print('  - Título: ${tema.titulo}');
        print('  - Autor: ${tema.autor}');

        // Invalidar todos los providers relacionados
        ref.invalidate(temasListProvider);
        ref.invalidate(misTemasProvider);

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Tema publicado correctamente!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        // Volver con resultado exitoso
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Nuevo Tema', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      'Publicar',
                      style: AppTextStyles.titleSmall
                          .copyWith(color: AppColors.primary),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícono decorativo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Vehículo info
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Publicando en vehículo ID: ${widget.vehiculoId}',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Título
              Text('Título', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tituloCtrl,
                maxLength: 120,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: '¿De qué trata tu tema?',
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  if (v.trim().length < 5) return 'Mínimo 5 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Descripción
              Text('Descripción', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 6,
                minLines: 4,
                maxLength: 1000,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Explica tu tema con detalle...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (v.trim().length < 10) return 'Mínimo 10 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón publicar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: const Text('Publicar Tema'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
