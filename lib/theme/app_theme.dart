import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double cardRadius = 14;

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColorsDark.background,
        surface: AppColorsDark.surface,
        card: AppColorsDark.card,
        accent: AppColorsDark.accent,
        textPrimary: AppColorsDark.textPrimary,
        textSecondary: AppColorsDark.textSecondary,
        border: AppColorsDark.border,
      );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColorsLight.background,
        surface: AppColorsLight.surface,
        card: AppColorsLight.card,
        accent: AppColorsLight.accent,
        textPrimary: AppColorsLight.textPrimary,
        textSecondary: AppColorsLight.textSecondary,
        border: AppColorsLight.border,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color card,
    required Color accent,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
  }) {
    final textTheme = TextTheme(
      // Números grandes (totales, importes destacados)
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        letterSpacing: -1,
        color: textPrimary,
      ),
      // Títulos de sección (uppercase aplicado en el widget)
      labelSmall: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: textSecondary,
      ),
      bodyMedium: TextStyle(fontSize: 12, color: textPrimary),
      bodySmall: TextStyle(fontSize: 11, color: textSecondary),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
        secondary: accent,
        onSecondary: brightness == Brightness.dark ? Colors.black : Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: AppColorsDark.negative,
        onError: Colors.white,
      ),
      fontFamily: 'Roboto',
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }
}
