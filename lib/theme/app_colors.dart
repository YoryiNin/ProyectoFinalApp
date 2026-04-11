import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primarios ──────────────────────────────────────────
  static const Color primary = Color(0xFFFF4500); // Naranja racing (botón CTA)
  static const Color primaryLight =
      Color(0xFFFF6B35); // Naranja hover / gradiente
  static const Color primaryDark = Color(0xFFCC3700); // Naranja pressed

  // ── Fondos ─────────────────────────────────────────────
  static const Color background =
      Color(0xFF0A0A0A); // Negro profundo (fondo principal)
  static const Color surface = Color(0xFF141414); // Superficie elevada (cards)
  static const Color surfaceVariant =
      Color(0xFF1E1E1E); // Cards secundarias / inputs
  static const Color overlay = Color(0xFF2A2A2A); // Bordes, dividers

  // ── Texto ──────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF); // Blanco puro (headings)
  static const Color textSecondary =
      Color(0xFFB0B0B0); // Gris claro (subtítulos)
  static const Color textHint = Color(0xFF666666); // Placeholder / disabled
  static const Color textOnPrimary =
      Color(0xFFFFFFFF); // Texto sobre botón naranja

  // ── Estados ────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Gomas (status badges) ──────────────────────────────
  static const Color gomaGood = Color(0xFF22C55E); // Buena
  static const Color gomaRegular = Color(0xFFFBBF24); // Regular
  static const Color gomaBad = Color(0xFFEF4444); // Mala
  static const Color gomaReplaced = Color(0xFF3B82F6); // Reemplazada

  // ── Gradientes ─────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC000000)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF4500)],
  );

  // ── Utilidad ───────────────────────────────────────────
  static const Color divider = Color(0xFF2A2A2A);
  static const Color shimmerBase = Color(0xFF1E1E1E);
  static const Color shimmerHighlight = Color(0xFF2A2A2A);
  static const Color transparent = Colors.transparent;
}
