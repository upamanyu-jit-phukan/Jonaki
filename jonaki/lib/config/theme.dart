import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6A9AB0),   // Soft blue
      secondary: Color(0xFFF2D7D9), // Light pastel pink
      surface: Color(0xFFF9F9F9),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6A9AB0),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 20, color: Colors.black87),
    ),
  );
}
