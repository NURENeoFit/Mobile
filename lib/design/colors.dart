import 'package:flutter/material.dart';

final ThemeData previousAppTheme = ThemeData(primarySwatch: Colors.blue);

final ThemeData customAppTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF7E57C2),
    onPrimary: Colors.white,
    secondary: Color(0xFF4CAF50),
    onSecondary: Colors.white,
    surface: Color(0xFFF0F0F0),
    onSurface: Colors.black87,
    error: Color(0xFFE53935),
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF9F6FC),
  useMaterial3: true,
);