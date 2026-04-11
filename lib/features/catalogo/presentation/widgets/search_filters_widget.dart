import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../providers/catalogo_provider.dart';

class SearchFiltersWidget extends ConsumerStatefulWidget {
  const SearchFiltersWidget({super.key});

  @override
  ConsumerState<SearchFiltersWidget> createState() =>
      _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends ConsumerState<SearchFiltersWidget> {
  bool _expanded = false;

  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _anioCtrl = TextEditingController();
  final _precioMinCtrl = TextEditingController();
  final _precioMaxCtrl = TextEditingController();

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _anioCtrl.dispose();
    _precioMinCtrl.dispose();
    _precioMaxCtrl.dispose();
    super.dispose();
  }

  void _aplicarFiltros() {
    final notifier = ref.read(catalogoFiltrosProvider.notifier);
    notifier.setMarca(_marcaCtrl.text);
    notifier.setModelo(_modeloCtrl.text);
    notifier.setAnio(_anioCtrl.text);
    notifier.setPrecioMin(_precioMinCtrl.text);
    notifier.setPrecioMax(_precioMaxCtrl.text);
    ref.invalidate(catalogoListProvider);
    setState(() => _expanded = false);
  }

  void _limpiarFiltros() {
    _marcaCtrl.clear();
    _modeloCtrl.clear();
    _anioCtrl.clear();
    _precioMinCtrl.clear();
    _precioMaxCtrl.clear();
    ref.read(catalogoFiltrosProvider.notifier).limpiarFiltros();
    ref.invalidate(catalogoListProvider);
    setState(() => _expanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final filtros = ref.watch(catalogoFiltrosProvider);
    final hayFiltros = !filtros.estaVacio;

    return Column(
      children: [
        // Botón toggle filtros
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hayFiltros ? AppColors.primary : AppColors.overlay,
                width: hayFiltros ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: hayFiltros ? AppColors.primary : AppColors.textHint,
                ),
                const SizedBox(width: 8),
                Text(
                  hayFiltros ? 'Filtros activos' : 'Filtrar búsqueda',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: hayFiltros
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (hayFiltros)
                  GestureDetector(
                    onTap: _limpiarFiltros,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),

        // Panel expandible
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildFiltrosPanel(),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildFiltrosPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Column(
        children: [
          // Marca y Modelo en fila
          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: _marcaCtrl,
                  label: 'Marca',
                  hint: 'Toyota, Honda…',
                  icon: Icons.branding_watermark_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildField(
                  controller: _modeloCtrl,
                  label: 'Modelo',
                  hint: 'Corolla, Civic…',
                  icon: Icons.directions_car_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Año
          _buildField(
            controller: _anioCtrl,
            label: 'Año',
            hint: '2020',
            icon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),

          // Precio mín y máx
          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: _precioMinCtrl,
                  label: 'Precio mín (RD\$)',
                  hint: '500,000',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildField(
                  controller: _precioMaxCtrl,
                  label: 'Precio máx (RD\$)',
                  hint: '2,000,000',
                  icon: Icons.money_off_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _limpiarFiltros,
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _aplicarFiltros,
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const Text('Buscar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
