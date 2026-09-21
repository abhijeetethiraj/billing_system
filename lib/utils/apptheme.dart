import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.brand,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: const Color(0xFF212121),
    onSurfaceVariant: const Color(0xFF616161),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: const Color(0xFFFAFAFA),
    surfaceContainer: Colors.white,
    surfaceContainerHigh: const Color(0xFFF0F0F0),
    surfaceContainerHighest: const Color(0xFFF5F5F5),
    outlineVariant: const Color(0xFFE0E0E0),
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.brand,
    onPrimary: Colors.white,
    surface: const Color(0xFF121212),
    onSurface: const Color(0xFFEDEDED),
    onSurfaceVariant: const Color(0xFFB3B3B3),
    surfaceContainerLowest: const Color(0xFF0D0D0D),
    surfaceContainerLow: const Color(0xFF121212),
    surfaceContainer: const Color(0xFF1E1E1E),
    surfaceContainerHigh: const Color(0xFF262626),
    surfaceContainerHighest: const Color(0xFF2C2C2C),
    outlineVariant: const Color(0xFF3A3A3A),
  );

  static ThemeData get light => _build(_lightScheme);
  static ThemeData get dark => _build(_darkScheme);

  static ThemeData _build(ColorScheme cs) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.onSurface,
        unselectedItemColor: cs.onSurfaceVariant,
      ),
      dividerTheme: DividerThemeData(color: cs.outlineVariant),
    );
  }
}

extension AppThemeContext on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get deepAccent => isDark ? AppColors.deepDark : AppColors.deepLight;
}