import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../domain/entities/tema_entity.dart';
import '../providers/foro_provider.dart';
import '../widgets/respuesta_card.dart';

class ForoDetalleScreen extends ConsumerStatefulWidget {
  final String temaId;

  const ForoDetalleScreen({super.key, required this.temaId});

  @override
  ConsumerState<ForoDetalleScreen> createState() => _ForoDetalleScreenState();
}

class _ForoDetalleScreenState extends ConsumerState<ForoDetalleScreen> {
  final TextEditingController _respuestaController = TextEditingController();
  bool _isRespondiendo = false;

  @override
  void dispose() {
    _respuestaController.dispose();
    super.dispose();
  }

  String _proxy(String url) =>
      'https://taller-itla.ia3x.com/api/imagen?url=${Uri.encodeComponent(url)}';

  Future<void> _enviarRespuesta(String temaId) async {
    final contenido = _respuestaController.text.trim();
    if (contenido.isEmpty) return;

    setState(() => _isRespondiendo = true);

    final result =
        await ref.read(responderTemaUseCaseProvider)(temaId, contenido);

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (_) {
        _respuestaController.clear();
        ref.invalidate(temaDetalleProvider(temaId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Respuesta enviada correctamente'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );

    setState(() => _isRespondiendo = false);
  }

  @override
  Widget build(BuildContext context) {
    final temaAsync = ref.watch(temaDetalleProvider(widget.temaId));
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Foro', style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: temaAsync.when(
        data: (tema) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Encabezado del tema
                  _buildTemaHeader(tema),

                  // Banner de autenticación o campo de respuesta
                  if (!isAuthenticated) _buildBannerNoAutenticado(),

                  const SizedBox(height: 16),

                  // Sección de respuestas
                  _buildRespuestasSection(tema),

                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Campo de respuesta solo si está autenticado
            if (isAuthenticated) _buildResponderWidget(),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => _buildError(context),
      ),
    );
  }

  Widget _buildTemaHeader(TemaEntity tema) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.overlay, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tema.titulo, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),

          // Foto del vehículo si existe
          if (tema.vehiculoFotoUrl != null &&
              tema.vehiculoFotoUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: _proxy(tema.vehiculoFotoUrl!),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 180,
                  color: AppColors.surfaceVariant,
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 100,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.directions_car_outlined,
                      color: AppColors.textHint, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Descripción
          Text(tema.descripcion, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 14),

          // Meta info
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(tema.autor, style: AppTextStyles.bodySmall),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_outlined,
                  size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(tema.fecha, style: AppTextStyles.bodySmall),
            ],
          ),

          if (tema.vehiculo != null && tema.vehiculo!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.directions_car_outlined,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(tema.vehiculo!, style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBannerNoAutenticado() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 14, color: AppColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Inicia sesión para responder este tema',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRespuestasSection(TemaEntity tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('RESPUESTAS',
                  style: AppTextStyles.labelMedium
                      .copyWith(letterSpacing: 1.5, color: AppColors.textHint)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${tema.cantidadRespuestas}',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (tema.respuestas.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      size: 40, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text('Sin respuestas aún',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textHint)),
                ],
              ),
            ),
          )
        else
          ...tema.respuestas.asMap().entries.map(
                (e) => RespuestaCard(respuesta: e.value, index: e.key),
              ),
      ],
    );
  }

  Widget _buildResponderWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.overlay),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _respuestaController,
              decoration: const InputDecoration(
                hintText: 'Escribe tu respuesta...',
                hintStyle: TextStyle(color: AppColors.textHint),
                border: InputBorder.none,
              ),
              maxLines: 3,
              minLines: 1,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 22,
            child: IconButton(
              icon: _isRespondiendo
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, size: 18, color: Colors.white),
              onPressed: _isRespondiendo
                  ? null
                  : () => _enviarRespuesta(widget.temaId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('No se pudo cargar el tema', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }
}
