import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D0014),
    primaryColor: const Color(0xFF6C4AB6),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6C4AB6),
      secondary: Color(0xFF9B7EDE),
      surface: Color(0xFF1A0B2E),
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F3FA),
    primaryColor: const Color(0xFF6C4AB6),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C4AB6),
      secondary: Color(0xFF9B7EDE),
      surface: Colors.white,
    ),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
  );
}