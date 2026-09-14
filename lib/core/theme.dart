import 'package:flutter/material.dart';

/// Visual language inspired by the Codenotch usage pill (dark surface, warm ring).
abstract final class CodenotchTheme {
  static const Color seed = Color(0xFFE8C07A);

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
