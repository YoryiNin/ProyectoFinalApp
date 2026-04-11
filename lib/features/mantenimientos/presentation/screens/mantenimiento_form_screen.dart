import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/mantenimientos_provider.dart';
import '../widgets/multi_photo_picker.dart';

class MantenimientoFormScreen extends ConsumerStatefulWidget {
  final String vehiculoId;

  const MantenimientoFormScreen({super.key, required this.vehiculoId});

  @override
  ConsumerState<MantenimientoFormScreen> createState() =>
      _MantenimientoFormScreenState();
}

class _MantenimientoFormScreenState
    extends ConsumerState<MantenimientoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoCtrl = TextEditingController();
  final _costoCtrl = TextEditingController();
  final _piezasCtrl = TextEditingController();
  final _tallerCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  List<File> _fotos = [];
  bool _isLoading = false;

  final List<String> _tiposMantenimiento = [
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
  void dispose() {
    _tipoCtrl.dispose();
    _costoCtrl.dispose();
    _piezasCtrl.dispose();
    _tallerCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _fechaSeleccionada = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'vehiculo_id': widget.vehiculoId,
      'tipo': _tipoCtrl.text.trim(),
      'costo': double.tryParse(_costoCtrl.text.trim()) ?? 0,
      'piezas':
          _piezasCtrl.text.trim().isEmpty ? null : _piezasCtrl.text.trim(),
      'fecha': _fechaSeleccionada.toIso8601String(),
      'taller':
          _tallerCtrl.text.trim().isEmpty ? null : _tallerCtrl.text.trim(),
      'observaciones': _observacionesCtrl.text.trim().isEmpty
          ? null
          : _observacionesCtrl.text.trim(),
    };

    // Convertir List<File> a List<String> (paths)
    final List<String> fotosPaths = _fotos.map((file) => file.path).toList();

    final result =
        await ref.read(createMantenimientoUseCaseProvider)(data, fotosPaths);

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
        title: Text('Nuevo Mantenimiento', style: AppTextStyles.titleMedium),
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
              // Tipo de mantenimiento
              DropdownButtonFormField<String>(
                value: _tipoCtrl.text.isEmpty ? null : _tipoCtrl.text,
                decoration: const InputDecoration(
                  labelText: 'Tipo de mantenimiento',
                  prefixIcon: Icon(Icons.build_outlined),
                ),
                items: _tiposMantenimiento.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) => _tipoCtrl.text = value ?? '',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecciona un tipo' : null,
              ),
              const SizedBox(height: 16),

              // Costo
              TextFormField(
                controller: _costoCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Costo (RD\$)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el costo';
                  if (double.tryParse(v) == null) return 'Costo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Piezas
              TextFormField(
                controller: _piezasCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Piezas (opcional)',
                  hintText: 'Ej: Filtro de aceite, pastillas de freno...',
                  prefixIcon: Icon(Icons.settings_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Taller
              TextFormField(
                controller: _tallerCtrl,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Taller (opcional)',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Fecha
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.overlay),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.textHint),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Fecha: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Observaciones
              TextFormField(
                controller: _observacionesCtrl,
                maxLines: 3,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Selector de fotos
              MultiPhotoPicker(
                selectedPhotos: _fotos,
                onPhotosChanged: (photos) => setState(() => _fotos = photos),
                maxPhotos: 5,
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
                      : const Text('Guardar Mantenimiento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
