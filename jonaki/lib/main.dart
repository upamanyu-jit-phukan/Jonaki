import 'package:flutter/material.dart';
import 'package:jonaki/config/theme.dart';
import 'package:jonaki/widgets/bottom_nav.dart';

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
    );
  }
}
