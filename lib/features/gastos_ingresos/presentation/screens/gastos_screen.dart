import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/gi_provider.dart';

class GastosScreen extends ConsumerStatefulWidget {
  final String vehiculoId;
  final String vehiculoNombre;

  const GastosScreen({
    super.key,
    required this.vehiculoId,
    required this.vehiculoNombre,
  });

  @override
  ConsumerState<GastosScreen> createState() => _GastosScreenState();
}

class _GastosScreenState extends ConsumerState<GastosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  String _categoriaSeleccionada = '';
  List<Map<String, dynamic>> _categorias = [];
  DateTime _fecha = DateTime.now();
  bool _showForm = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    final result = await ref.read(getCategoriasUseCaseProvider)();
    result.fold(
      (error) => print('Error loading categorias: $error'),
      (categorias) {
        setState(() {
          _categorias = categorias
              .map((c) => {
                    'id': c.id,
                    'nombre': c.nombre,
                  })
              .toList();
          if (_categorias.isNotEmpty) {
            _categoriaSeleccionada = _categorias.first['id'];
          }
        });
      },
    );
  }

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
      'categoria_id': _categoriaSeleccionada,
      'monto': double.tryParse(_montoCtrl.text.trim()) ?? 0,
      'descripcion': _descripcionCtrl.text.trim(),
      'fecha': _fecha.toIso8601String(),
    };

    final result = await ref.read(createGastoUseCaseProvider)(data);

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
        ref.invalidate(gastosListProvider(widget.vehiculoId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Gasto registrado'),
              backgroundColor: AppColors.success),
        );
      },
    );
  }

  double _calcularTotal(List<dynamic> gastos) {
    double total = 0;
    for (var g in gastos) {
      total += g.monto;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final gastosAsync = ref.watch(gastosListProvider(widget.vehiculoId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Gastos - ${widget.vehiculoNombre}',
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
                    DropdownButtonFormField<String>(
                      value: _categoriaSeleccionada.isEmpty
                          ? null
                          : _categoriaSeleccionada,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: _categorias.map<DropdownMenuItem<String>>((c) {
                        // Especificamos el tipo explícitamente
                        return DropdownMenuItem<String>(
                          value: c['id'] as String,
                          child: Text(c['nombre'] as String),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => _categoriaSeleccionada = v ?? ''),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Selecciona una categoría'
                          : null,
                    ),
                    const SizedBox(height: 12),
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
          // Total de gastos
          gastosAsync.when(
            data: (gastos) => Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_down,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL GASTOS',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(
                          NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$')
                              .format(_calcularTotal(gastos)),
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
            child: gastosAsync.when(
              data: (gastos) {
                if (gastos.isEmpty && !_showForm) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.money_off_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('Sin gastos registrados',
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
                    ref.invalidate(gastosListProvider(widget.vehiculoId));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: gastos.length,
                    itemBuilder: (ctx, i) {
                      final g = gastos[i];
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
                                color: AppColors.error.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.trending_down,
                                  color: AppColors.error),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(g.categoriaNombre,
                                      style: AppTextStyles.titleSmall),
                                  Text(g.descripcion,
                                      style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  g.montoFormatted,
                                  style: AppTextStyles.titleSmall
                                      .copyWith(color: AppColors.error),
                                ),
                                Text(
                                  g.fechaFormatted,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
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
                      onPressed: () =>
                          ref.invalidate(gastosListProvider(widget.vehiculoId)),
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
