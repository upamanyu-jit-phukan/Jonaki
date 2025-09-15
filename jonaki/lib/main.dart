import 'package:flutter/material.dart';
import 'package:jonaki/widgets/bottom_nav.dart';
import '../theme/colors.dart'; // your Jonaki color constants

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jonaki',
      theme: AppTheme.lightTheme,
      home: const MainPage(),
      // home: const Center(child: Text('hello'),),
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGold,
      primary: kGold,
      secondary: kOffNavy,
      surface: Colors.white,          // all surfaces (cards, sheets) white
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kOffNavy,            // text/icons on white surface
      error: Colors.redAccent,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white, // Scaffold background pure white
    appBarTheme: const AppBarTheme(
      backgroundColor: kOffNavy,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kGold,
    ),
    fontFamily: 'Roboto',
  );
}
