import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

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

    setState(() => _isLoading = true);

    // Aquí iría la llamada al endpoint /foro/crear
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Tema creado exitosamente'),
          backgroundColor: AppColors.success),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Crear Tema', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nuevo tema en el foro',
                  style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Comparte tus experiencias con la comunidad',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _tituloCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Título del tema',
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 8,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Descripción / Contenido',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Escribe el contenido' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Publicar Tema'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
