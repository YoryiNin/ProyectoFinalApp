import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String youtubeId;
  final String titulo;
  final String? descripcion;
  final String? categoria;

  const VideoPlayerScreen({
    super.key,
    required this.youtubeId,
    required this.titulo,
    this.descripcion,
    this.categoria,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.titulo, style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player
          YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9,
          ),

          // Info del video
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría badge
                  if (widget.categoria != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        widget.categoria!.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Título
                  Text(widget.titulo, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),

                  // Divider
                  Divider(color: AppColors.overlay, thickness: 0.5),
                  const SizedBox(height: 12),

                  // Descripción
                  if (widget.descripcion != null &&
                      widget.descripcion!.isNotEmpty)
                    Text(
                      widget.descripcion!,
                      style: AppTextStyles.bodyMedium,
                    )
                  else
                    Text(
                      'Disfruta de este video educativo sobre mantenimiento vehicular. '
                      'Aprende consejos prácticos para mantener tu auto en óptimas condiciones.',
                      style: AppTextStyles.bodyMedium,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
