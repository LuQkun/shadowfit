// ============================================================
// theme.dart – ShadowFit Global Theme
// Dark anime aesthetic with neon purple/cyan accents
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  // ── Core Colors ─────────────────────────────────────────
  static const Color background    = Color(0xFF07071A);
  static const Color cardBg        = Color(0xFF0F0F2A);
  static const Color surfaceDark   = Color(0xFF12122E);
  static const Color primaryPurple = Color(0xFF7B2FBE);
  static const Color neonPurple    = Color(0xFFBB86FC);
  static const Color neonCyan      = Color(0xFF00E5FF);
  static const Color neonBlue      = Color(0xFF448AFF);
  static const Color textPrimary   = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0CC);

  // ── Gradients ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7B2FBE), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF12122E), Color(0xFF1A1A42)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glow BoxShadows ──────────────────────────────────────
  static List<BoxShadow> purpleGlow = [
    BoxShadow(
      color: const Color(0xFF7B2FBE).withOpacity(0.55),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: const Color(0xFF00E5FF).withOpacity(0.45),
      blurRadius: 18,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> cardGlow = [
    BoxShadow(
      color: const Color(0xFF7B2FBE).withOpacity(0.25),
      blurRadius: 12,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];

  // ── MaterialApp ThemeData ────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primaryPurple,
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: neonCyan,
      surface: surfaceDark,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.5,
      ),
      iconTheme: IconThemeData(color: neonPurple),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0F0F2A),
      selectedItemColor: neonPurple,
      unselectedItemColor: Color(0xFF555580),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 10),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF0A0A22),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBg,
      labelStyle: const TextStyle(color: neonPurple),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryPurple.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: neonPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
    ),
  );
}
