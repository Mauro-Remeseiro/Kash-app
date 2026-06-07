import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Acceso a los colores semánticos (positivo, negativo, bordes, etc.) que no
/// forman parte del [ColorScheme] de Material pero están definidos en
/// [AppColorsDark] / [AppColorsLight] según el brillo activo.
class KashColors {
  const KashColors({
    required this.border,
    required this.positive,
    required this.negative,
    required this.infoBlue,
    required this.accentDim,
    required this.negativeDim,
    required this.textTertiary,
  });

  final Color border;
  final Color positive;
  final Color negative;
  final Color infoBlue;
  final Color accentDim;
  final Color negativeDim;
  final Color textTertiary;

  static const KashColors dark = KashColors(
    border: AppColorsDark.border,
    positive: AppColorsDark.positive,
    negative: AppColorsDark.negative,
    infoBlue: AppColorsDark.infoBlue,
    accentDim: AppColorsDark.accentDim,
    negativeDim: AppColorsDark.negativeDim,
    textTertiary: AppColorsDark.textTertiary,
  );

  static const KashColors light = KashColors(
    border: AppColorsLight.border,
    positive: AppColorsLight.positive,
    negative: AppColorsLight.negative,
    infoBlue: AppColorsLight.infoBlue,
    accentDim: AppColorsLight.accentDim,
    negativeDim: AppColorsLight.negativeDim,
    textTertiary: AppColorsLight.textTertiary,
  );
}

KashColors kashColorsOf(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark ? KashColors.dark : KashColors.light;
}
