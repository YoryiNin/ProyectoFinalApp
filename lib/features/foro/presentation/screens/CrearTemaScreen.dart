import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/foro_provider.dart';

class CrearTemaScreen extends ConsumerStatefulWidget {
  const CrearTemaScreen({super.key});

  @override
  ConsumerState<CrearTemaScreen> createState() => _CrearTemaScreenState();
}

class _CrearTemaScreenState extends ConsumerState<CrearTemaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  // Si tienes vehiculos del usuario, carga la lista y usa un dropdown.
  // Por ahora usamos un TextField simple para el vehiculo_id.
  final _vehiculoIdCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    _vehiculoIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await ref.read(crearTemaUseCaseProvider).call(
          _vehiculoIdCtrl.text.trim(),
          _tituloCtrl.text.trim(),
          _descripcionCtrl.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (tema) {
        // Invalidar la lista para que se refresque
        ref.invalidate(temasListProvider);
        ref.invalidate(misTemasProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tema publicado correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // true = fue creado
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

              // ID del vehículo
              Text('Vehículo', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _vehiculoIdCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'ID de tu vehículo',
                  prefixIcon: Icon(Icons.directions_car_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Ingresa el ID de tu vehículo';
                  }
                  return null;
                },
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
                  if (v.trim().length < 5) {
                    return 'Mínimo 5 caracteres';
                  }
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
                  if (v.trim().length < 10) {
                    return 'Mínimo 10 caracteres';
                  }
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
