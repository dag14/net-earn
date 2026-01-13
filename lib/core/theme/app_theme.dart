import 'package:flutter/material.dart';

class AppTheme {
  /* =========================================================
   * Brand Colors (Inspired by Arsenal Teal Jacket)
   * ========================================================= */

  // Main Teal Palette
  static const Color tealDark = Color(0xFF004D40); // Dark teal (jacket body)
  static const Color teal = Color(0xFF00695C); // Medium teal (primary)
  static const Color tealLight = Color(
    0xFF4DB6AC,
  ); // Light teal (secondary areas)

  // Mint / Pale Green Accent (side panels)
  static const Color mint = Color(0xFFC8E6C9);

  // Accent color for buttons, highlights
  static const Color whiteAccent = Colors.white;

  // Accent (retain your amber for contrast)
  static const Color amber = Color(0xFFFFC107);

  // Status colors
  static const Color red = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color blue = Color.fromARGB(255, 146, 191, 228);
  static const Color purple = Color(0xFF6A0DAD);

  /* =========================================================
   * Light Theme Colors
   * ========================================================= */

  static const Color lightScaffold = Color(0xFFF9FAFB);
  static const Color lightSurface = Colors.white;

  static const Color lightTitle = Color(0xFF102A2A);
  static const Color lightBody = Color(0xFF37474F);
  static const Color lightHint = Color(0xFF78909C);

  /* =========================================================
   * Dark Theme Colors
   * ========================================================= */

  static const Color darkScaffold = Color(0xFF0F1F1E);
  static const Color darkSurface = Color(0xFF1C2B2A);

  static const Color darkTitle = Color(0xFFE0F2F1);
  static const Color darkBody = Color(0xFFB2DFDB);
  static const Color darkHint = Color(0xFF78909C);

  /* =========================================================
   * Text Styles
   * ========================================================= */

  static const TextStyle headline = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /* =========================================================
   * Light Theme
   * ========================================================= */

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightScaffold,

    colorScheme: const ColorScheme.light(
      primary: teal, // medium teal as primary
      secondary: mint, // mint accent for secondary
      error: red,
      surface: lightSurface,
      onPrimary: whiteAccent, // text/icons on primary
      onSecondary: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: tealDark,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    textTheme: TextTheme(
      titleLarge: headline.copyWith(color: lightTitle),
      bodyMedium: body.copyWith(color: lightBody),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      labelStyle: body.copyWith(color: lightBody),
      hintStyle: const TextStyle(color: Color(0xFF78909C)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: teal),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: teal,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
    ),
  );

  /* =========================================================
   * Dark Theme
   * ========================================================= */

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScaffold,

    colorScheme: const ColorScheme.dark(
      primary: tealLight, // lighter teal in dark mode
      secondary: mint, // mint accent in dark mode too
      error: red,
      surface: darkSurface,
      onPrimary: Color(0xFF00201D),
      onSecondary: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF004D40), // dark teal
      foregroundColor: darkTitle,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF223332),
      labelStyle: body.copyWith(color: darkBody),
      hintStyle: TextStyle(color: darkHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: tealLight),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: tealLight,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
    ),
  );
}
