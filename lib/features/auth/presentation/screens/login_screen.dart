import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taller_itla_app/core/router/route_names.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import 'registro_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _matriculaCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authProvider.notifier).login(
          _matriculaCtrl.text.trim(),
          _passCtrl.text.trim(),
        );
    if (!mounted) return;
    if (ok) {
      context.go(RouteNames.dashboard);
    } else {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Error al iniciar sesión'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _olvidarClave() async {
    final matricula = _matriculaCtrl.text.trim();
    if (matricula.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa tu matrícula primero'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    final ok = await ref.read(authProvider.notifier).olvidarClave(matricula);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Se ha enviado una nueva contraseña a tu correo'
            : ref.read(authProvider).error ?? 'Error'),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: Text('AutoGestor', style: AppTextStyles.headlineLarge),
                ),
                Center(
                  child: Text('ITLA', style: AppTextStyles.headlineAccent),
                ),
                const SizedBox(height: 48),

                Text('Iniciar Sesión', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 24),

                // Matrícula
                TextFormField(
                  controller: _matriculaCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Matrícula',
                    hintText: 'Ej: 2021-0001',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Ingresa tu matrícula'
                      : null,
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingresa tu contraseña' : null,
                ),

                // Olvidar clave
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _olvidarClave,
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón login
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
                        : const Text('Iniciar Sesión'),
                  ),
                ),

                const SizedBox(height: 20),

                // Link registro
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegistroScreen()),
                    ),
                    child: const Text('¿No tienes cuenta? Regístrate'),
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
