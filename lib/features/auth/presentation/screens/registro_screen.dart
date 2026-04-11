import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import 'activar_screen.dart';

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaCtrl = TextEditingController();

  @override
  void dispose() {
    _matriculaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final token = await ref
        .read(authProvider.notifier)
        .registro(_matriculaCtrl.text.trim());
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ActivarScreen(tokenTemporal: token),
        ),
      );
    } else {
      final error = ref.read(authProvider).error;
      _showError(error ?? 'Error en el registro');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registro', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Ícono
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text('Crear cuenta', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tu matrícula del ITLA para comenzar.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Campo matrícula
                TextFormField(
                  controller: _matriculaCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Matrícula',
                    hintText: 'Ej: 2021-0001',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa tu matrícula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botón
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Continuar'),
                  ),
                ),

                const SizedBox(height: 20),

                // Link a login
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
