import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/vehiculos_provider.dart';

class VehiculoFormScreen extends ConsumerStatefulWidget {
  final String? vehiculoId;
  final Map<String, dynamic>? initialData;

  const VehiculoFormScreen({super.key, this.vehiculoId, this.initialData});

  @override
  ConsumerState<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends ConsumerState<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placaCtrl = TextEditingController();
  final _chasisCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _anioCtrl = TextEditingController();
  File? _fotoSeleccionada;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _placaCtrl.text = widget.initialData!['placa'] ?? '';
      _chasisCtrl.text = widget.initialData!['chasis'] ?? '';
      _marcaCtrl.text = widget.initialData!['marca'] ?? '';
      _modeloCtrl.text = widget.initialData!['modelo'] ?? '';
      _anioCtrl.text = widget.initialData!['anio']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _placaCtrl.dispose();
    _chasisCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _anioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _fotoSeleccionada = File(file.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'placa': _placaCtrl.text.trim().toUpperCase(),
      'chasis': _chasisCtrl.text.trim().toUpperCase(),
      'marca': _marcaCtrl.text.trim(),
      'modelo': _modeloCtrl.text.trim(),
      'anio': int.tryParse(_anioCtrl.text.trim()) ?? 0,
    };

    final result = await ref.read(createVehiculoUseCaseProvider)(
      data,
      _fotoSeleccionada?.path,
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (_) {
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.vehiculoId == null ? 'Nuevo Vehículo' : 'Editar Vehículo',
          style: AppTextStyles.titleMedium,
        ),
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
              // Foto
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.overlay),
                        ),
                        child: _fotoSeleccionada != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _fotoSeleccionada!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.directions_car_outlined,
                                size: 48,
                                color: AppColors.textHint,
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Placa
              TextFormField(
                controller: _placaCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  hintText: 'Ej: A123456',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa la placa' : null,
              ),
              const SizedBox(height: 16),

              // Chasis
              TextFormField(
                controller: _chasisCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Número de Chasis',
                  hintText: 'Ej: 1HGCM82633A123456',
                  prefixIcon: Icon(Icons.qr_code_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa el chasis' : null,
              ),
              const SizedBox(height: 16),

              // Marca
              TextFormField(
                controller: _marcaCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  hintText: 'Ej: Toyota, Honda, Ford...',
                  prefixIcon: Icon(Icons.branding_watermark_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa la marca' : null,
              ),
              const SizedBox(height: 16),

              // Modelo
              TextFormField(
                controller: _modeloCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  hintText: 'Ej: Corolla, Civic, F-150...',
                  prefixIcon: Icon(Icons.directions_car_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa el modelo' : null,
              ),
              const SizedBox(height: 16),

              // Año
              TextFormField(
                controller: _anioCtrl,
                style: AppTextStyles.bodyMedium,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  hintText: 'Ej: 2020',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el año';
                  final year = int.tryParse(v);
                  if (year == null ||
                      year < 1900 ||
                      year > DateTime.now().year + 1) {
                    return 'Año inválido';
                  }
                  return null;
                },
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
                      : const Text('Guardar Vehículo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
