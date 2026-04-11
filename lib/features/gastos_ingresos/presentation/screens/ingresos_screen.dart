import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/gi_provider.dart';

class IngresosScreen extends ConsumerStatefulWidget {
  final String vehiculoId;
  final String vehiculoNombre;

  const IngresosScreen({
    super.key,
    required this.vehiculoId,
    required this.vehiculoNombre,
  });

  @override
  ConsumerState<IngresosScreen> createState() => _IngresosScreenState();
}

class _IngresosScreenState extends ConsumerState<IngresosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  DateTime _fecha = DateTime.now();
  bool _showForm = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _montoCtrl.dispose();
    _descripcionCtrl.dispose();
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
      'monto': double.tryParse(_montoCtrl.text.trim()) ?? 0,
      'descripcion': _descripcionCtrl.text.trim(),
      'fecha': _fecha.toIso8601String(),
    };

    final result = await ref.read(createIngresoUseCaseProvider)(data);

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (_) {
        setState(() {
          _showForm = false;
          _isLoading = false;
          _montoCtrl.clear();
          _descripcionCtrl.clear();
        });
        ref.invalidate(ingresosListProvider(widget.vehiculoId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ingreso registrado'),
              backgroundColor: AppColors.success),
        );
      },
    );
  }

  double _calcularTotal(List<dynamic> ingresos) {
    double total = 0;
    for (var i in ingresos) {
      total += i.monto;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final ingresosAsync = ref.watch(ingresosListProvider(widget.vehiculoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Ingresos - ${widget.vehiculoNombre}',
            style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add,
                color: AppColors.primary),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showForm)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.overlay),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _montoCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto (RD\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingresa el monto' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descripcionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Ingresa una descripción'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _showForm = false),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Total de ingresos
          ingresosAsync.when(
            data: (ingresos) => Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL INGRESOS',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(
                          NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$')
                              .format(_calcularTotal(ingresos)),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: ingresosAsync.when(
              data: (ingresos) {
                if (ingresos.isEmpty && !_showForm) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('Sin ingresos registrados',
                            style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 8),
                        Text('Toca el botón + para agregar',
                            style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref.invalidate(ingresosListProvider(widget.vehiculoId));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ingresos.length,
                    itemBuilder: (ctx, i) {
                      final ing = ingresos[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.overlay),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.trending_up,
                                  color: AppColors.success),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ing.descripcion,
                                      style: AppTextStyles.titleSmall),
                                  Text(ing.fechaFormatted,
                                      style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              ing.montoFormatted,
                              style: AppTextStyles.titleSmall
                                  .copyWith(color: AppColors.success),
                            ),
                          ],
                        ),
                      );
                    },
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
                    ElevatedButton(
                      onPressed: () => ref
                          .invalidate(ingresosListProvider(widget.vehiculoId)),
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
