import 'package:flutter/material.dart';

class DraksonPalette {
  static const bg = Color(0xFFFFFDF9);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFEFE9DF);
  static const accent = Color(0xFFF97316);
  static const accent2 = Color(0xFFFDBA74);
  static const ink = Color(0xFF291804);
  static const inkMuted = Color(0xFF78716C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'AppFont',
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        surface: surface,
        primary: accent,
        secondary: accent2,
        onSurface: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent2.withAlpha(80),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ink),
        ),
      ),
    );
  }
}
