import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/catalogo_vehiculo_entity.dart';
import '../providers/catalogo_provider.dart';

class CatalogoDetalleScreen extends ConsumerStatefulWidget {
  final String id;
  final CatalogoVehiculoEntity? vehiculoPreview;

  const CatalogoDetalleScreen({
    super.key,
    required this.id,
    this.vehiculoPreview,
  });

  @override
  ConsumerState<CatalogoDetalleScreen> createState() =>
      _CatalogoDetalleScreenState();
}

class _CatalogoDetalleScreenState extends ConsumerState<CatalogoDetalleScreen> {
  int _imagenActual = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _proxyUrl(String url) {
    if (url.isEmpty) return '';
    return 'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';
  }

  String _formatPrecio(double precio) {
    if (precio <= 0) return 'Precio a consultar';
    final p = precio.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'RD\$ $p';
  }

  @override
  Widget build(BuildContext context) {
    // Usar preview mientras carga el detalle completo
    final preview = widget.vehiculoPreview;
    final detalleAsync = ref.watch(catalogoDetalleProvider(widget.id));

    return detalleAsync.when(
      data: (vehiculo) => _buildDetalle(context, vehiculo),
      loading: () => preview != null
          ? _buildDetalle(context, preview, cargando: true)
          : _buildLoading(context),
      error: (error, _) => preview != null
          ? _buildDetalle(context, preview)
          : _buildError(context, error),
    );
  }

  Widget _buildDetalle(
    BuildContext context,
    CatalogoVehiculoEntity vehiculo, {
    bool cargando = false,
  }) {
    final galeria = vehiculo.galeria.isNotEmpty
        ? vehiculo.galeria
        : (vehiculo.imagenUrl.isNotEmpty ? [vehiculo.imagenUrl] : <String>[]);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar con galería
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildGaleria(galeria),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${vehiculo.marca} ${vehiculo.modelo}',
                          style: AppTextStyles.headlineMedium,
                        ),
                      ),
                      if (cargando)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehiculo.anio}',
                    style: AppTextStyles.bodyMedium,
                  ),

                  const SizedBox(height: 16),

                  // Precio destacado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRECIO',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white70,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatPrecio(vehiculo.precio),
                          style: AppTextStyles.price.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Especificaciones
                  Text(
                    'ESPECIFICACIONES',
                    style: AppTextStyles.labelMedium.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildEspecificaciones(vehiculo),

                  // Descripción
                  if (vehiculo.descripcion != null &&
                      vehiculo.descripcion!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'DESCRIPCIÓN',
                      style: AppTextStyles.labelMedium.copyWith(
                        letterSpacing: 1.5,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vehiculo.descripcion!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],

                  // Miniaturas de galería
                  if (galeria.length > 1) ...[
                    const SizedBox(height: 24),
                    Text(
                      'GALERÍA',
                      style: AppTextStyles.labelMedium.copyWith(
                        letterSpacing: 1.5,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMiniaturasGaleria(galeria),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaleria(List<String> galeria) {
    if (galeria.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.directions_car_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Páginas de imágenes
        PageView.builder(
          controller: _pageController,
          itemCount: galeria.length,
          onPageChanged: (i) => setState(() => _imagenActual = i),
          itemBuilder: (_, i) {
            final url = _proxyUrl(galeria[i]);
            if (url.isEmpty) {
              return Container(color: AppColors.surfaceVariant);
            }
            return CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppColors.surfaceVariant),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: AppColors.textHint,
                ),
              ),
            );
          },
        ),

        // Gradiente abajo
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          ),
        ),

        // Indicador de página
        if (galeria.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                galeria.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _imagenActual == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _imagenActual == i
                        ? AppColors.primary
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

        // Contador de fotos (top-right)
        Positioned(
          top: 56,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_imagenActual + 1} / ${galeria.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniaturasGaleria(List<String> galeria) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: galeria.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final url = _proxyUrl(galeria[i]);
          final isSelected = _imagenActual == i;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.overlay,
                  width: isSelected ? 2 : 0.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: url.isEmpty
                  ? Container(color: AppColors.surfaceVariant)
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.surfaceVariant),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.surfaceVariant),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEspecificaciones(CatalogoVehiculoEntity vehiculo) {
    final specs = <Map<String, String>>[
      if (vehiculo.combustible != null && vehiculo.combustible!.isNotEmpty)
        {'label': 'Combustible', 'valor': vehiculo.combustible!, 'icon': '⛽'},
      if (vehiculo.transmision != null && vehiculo.transmision!.isNotEmpty)
        {'label': 'Transmisión', 'valor': vehiculo.transmision!, 'icon': '⚙️'},
      if (vehiculo.color != null && vehiculo.color!.isNotEmpty)
        {'label': 'Color', 'valor': vehiculo.color!, 'icon': '🎨'},
      if (vehiculo.millaje != null && vehiculo.millaje!.isNotEmpty)
        {'label': 'Millaje', 'valor': vehiculo.millaje!, 'icon': '🛣️'},
      if (vehiculo.condicion != null && vehiculo.condicion!.isNotEmpty)
        {'label': 'Condición', 'valor': vehiculo.condicion!, 'icon': '✅'},
      {'label': 'Año', 'valor': '${vehiculo.anio}', 'icon': '📅'},
    ];

    if (specs.isEmpty) {
      return Text(
        'No hay especificaciones disponibles.',
        style: AppTextStyles.bodyMedium,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Column(
        children: specs.asMap().entries.map((entry) {
          final i = entry.key;
          final spec = entry.value;
          final isLast = i == specs.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: AppColors.overlay,
                        width: 0.5,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Text(spec['icon']!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Text(
                  spec['label']!,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textHint),
                ),
                const Spacer(),
                Text(
                  spec['valor']!,
                  style: AppTextStyles.titleSmall,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Error al cargar el vehículo',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
