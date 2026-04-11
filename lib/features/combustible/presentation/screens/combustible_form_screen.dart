import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/combustible/presentation/providers/combustible_provider.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class CombustibleFormScreen extends ConsumerStatefulWidget {
  final String vehiculoId;

  const CombustibleFormScreen({super.key, required this.vehiculoId});

  @override
  ConsumerState<CombustibleFormScreen> createState() =>
      _CombustibleFormScreenState();
}

class _CombustibleFormScreenState extends ConsumerState<CombustibleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _tipo = 'combustible';
  final _cantidadCtrl = TextEditingController();
  String _unidad = 'galones';
  final _montoCtrl = TextEditingController();
  DateTime _fecha = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _cantidadCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'vehiculo_id': widget.vehiculoId,
      'tipo': _tipo,
      'cantidad': double.tryParse(_cantidadCtrl.text.trim()) ?? 0,
      'unidad': _unidad,
      'monto': double.tryParse(_montoCtrl.text.trim()) ?? 0,
      'fecha': _fecha.toIso8601String(),
    };

    final result = await ref.read(createCombustibleUseCaseProvider)(data);

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (_) => Navigator.pop(context, true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Nuevo Registro', style: AppTextStyles.titleMedium),
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
              // Tipo
              Text('TIPO', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'combustible', label: Text('⛽ Combustible')),
                  ButtonSegment(value: 'aceite', label: Text('🔧 Aceite')),
                ],
                selected: {_tipo},
                onSelectionChanged: (Set<String> selection) {
                  setState(() => _tipo = selection.first);
                  if (_tipo == 'combustible') {
                    _unidad = 'galones';
                  } else {
                    _unidad = 'qt';
                  }
                },
              ),
              const SizedBox(height: 24),

              // Cantidad
              TextFormField(
                controller: _cantidadCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  prefixIcon: const Icon(Icons.abc_outlined),
                  suffixText: _unidad == 'galones'
                      ? 'gal'
                      : (_unidad == 'litros' ? 'L' : 'qt'),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa la cantidad';
                  if (double.tryParse(v) == null) return 'Cantidad inválida';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unidad (solo para combustible)
              if (_tipo == 'combustible') ...[
                Text('UNIDAD', style: AppTextStyles.labelMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'galones', label: Text('Galones')),
                    ButtonSegment(value: 'litros', label: Text('Litros')),
                  ],
                  selected: {_unidad},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() => _unidad = selection.first);
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Monto - CORREGIDO: escapamos el símbolo $
              TextFormField(
                controller: _montoCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Monto (RD\$)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa el monto';
                  if (double.tryParse(v) == null) return 'Monto inválido';
                  return null;
                },
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
                          'Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: AppColors.textHint),
                    ],
                  ),
                ),
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
                      : const Text('Guardar Registro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
