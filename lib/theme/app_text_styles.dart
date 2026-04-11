import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografía inspirada en el estilo AutoZone / racing:
/// - Rajdhani o Bebas Neue para headings bold condensados
/// - Inter para cuerpo de texto
///
/// Agrega al pubspec.yaml:
/// dependencies:
///   google_fonts: ^6.x
///
/// Uso: GoogleFonts.rajdhani(...) o GoogleFonts.bebasNeue(...)
/// Si prefieres assets locales, descarga las fuentes y declara en flutter > fonts.

class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero (estilo "RIDE FAST") ───────────────────────────────────
  /// Headline gigante para sliders y hero screens
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Rajdhani', // Cambiar a 'BebasNeue' para look más extremo
    fontSize: 52,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: 2.0,
  );

  /// Headline mediano — pantallas de detalle
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: 1.5,
  );

  // ── Headings ──────────────────────────────────────────────────────────────
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 1.0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.8,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ── Accent (naranja — para palabras resaltadas como "FAST" / "SMART") ─────
  static const TextStyle displayAccent = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 52,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.0,
    letterSpacing: 2.0,
  );

  static const TextStyle headlineAccent = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
    letterSpacing: 1.0,
  );

  // ── Títulos de secciones / AppBar ─────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  // ── Cuerpo de texto ───────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.4,
  );

  // ── Labels / Botones ──────────────────────────────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.4,
  );

  // ── Badges / Chips ────────────────────────────────────────────────────────
  static const TextStyle badge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.8,
  );

  // ── Nav / Tab bar ─────────────────────────────────────────────────────────
  static const TextStyle navLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // ── Precio / Montos ───────────────────────────────────────────────────────
  static const TextStyle price = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.3,
  );

  // ── Placa / Código ────────────────────────────────────────────────────────
  static const TextStyle plateCode = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 3.0,
  );
}
