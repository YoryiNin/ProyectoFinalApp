import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taller_itla_app/features/noticias/presentation/screens/noticia_detalle_screen.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';
import '../../../../../core/widgets/main_scaffold.dart';

import '../providers/noticias_provider.dart';
import '../widgets/noticia_card.dart';

class NoticiasScreen extends ConsumerWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticiasAsync = ref.watch(noticiasListProvider);

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('NOTICIAS'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: noticiasAsync.when(
          data: (noticias) {
            if (noticias.isEmpty) {
              return const Center(child: Text('No hay noticias disponibles.'));
            }
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return NoticiaCard(
                  noticia: noticia,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticiaDetalleScreen(
                          id: noticia.id,
                          titulo: noticia.titulo,
                          contenidoHtml:
                              noticia.contenidoHtml ?? noticia.extracto,
                          // ← Ahora sí se pasa la imagen
                          imagenUrl: noticia.imagenUrl,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar noticias',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(noticiasListProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
