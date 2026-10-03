import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantische kleuren voor de houdbaarheidsstatus van een product.
///
/// Als [ThemeExtension] geregistreerd zodat widgets ze via
/// `Theme.of(context).extension<StatusColors>()` kunnen ophalen en ze
/// automatisch meebewegen met licht/donker.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.verlopen,
    required this.bijna,
    required this.ok,
  });

  /// Rood — houdbaarheidsdatum is verstreken.
  final Color verlopen;

  /// Oranje — verloopt binnen enkele dagen.
  final Color bijna;

  /// Neutraal — ruim houdbaar.
  final Color ok;

  @override
  StatusColors copyWith({Color? verlopen, Color? bijna, Color? ok}) {
    return StatusColors(
      verlopen: verlopen ?? this.verlopen,
      bijna: bijna ?? this.bijna,
      ok: ok ?? this.ok,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      verlopen: Color.lerp(verlopen, other.verlopen, t)!,
      bijna: Color.lerp(bijna, other.bijna, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
    );
  }
}

/// Het minimalistische Material 3-thema van de app, op één plek.
///
/// - Eén rustige, zachtgroene accentkleur
/// - Lichte én donkere variant
/// - Inter als tekstfont (via google_fonts)
/// - Afgeronde kaarten zonder zware schaduwen
class AppTheme {
  const AppTheme._();

  /// De zachtgroene basiskleur waaruit het kleurenschema wordt afgeleid.
  static const Color _seed = Color(0xFF5B9A78);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final isLight = brightness == Brightness.light;

    // Inter over het standaard Material-tekstthema heen.
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    final textTheme = GoogleFonts.interTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      // Rustige AppBar zonder zware schaduw.
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      // Afgeronde, vlakke kaarten met veel witruimte.
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      // Zwevende, afgeronde snackbars die losstaan van de onderrand.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        StatusColors(
          verlopen: isLight
              ? const Color(0xFFD1493C)
              : const Color(0xFFF2857A),
          bijna: isLight
              ? const Color(0xFFE08A2B)
              : const Color(0xFFF3B15A),
          ok: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
