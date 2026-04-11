import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class ResponderWidget extends StatefulWidget {
  final String temaId;
  final Function(String) onResponder;

  const ResponderWidget({
    super.key,
    required this.temaId,
    required this.onResponder,
  });

  @override
  State<ResponderWidget> createState() => _ResponderWidgetState();
}

class _ResponderWidgetState extends State<ResponderWidget> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _responder() async {
    final contenido = _controller.text.trim();
    if (contenido.isEmpty) return;

    setState(() => _isLoading = true);
    await widget.onResponder(contenido);
    _controller.clear();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.overlay)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send, size: 18, color: Colors.white),
              onPressed: _isLoading ? null : _responder,
            ),
          ),
        ],
      ),
    );
  }
}
