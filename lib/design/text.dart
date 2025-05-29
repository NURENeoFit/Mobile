import 'package:flutter/material.dart';

final TextTheme customTextTheme = const TextTheme(
  // Application: welcome screen, splash, large banners
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),

  // AppBar, like H1
  headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),

  // Section/Card/Block Title
  titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),

  // Main text (paragraphs, signatures, details)
  bodyLarge: TextStyle(fontSize: 16),
  bodyMedium: TextStyle(fontSize: 14),
  bodySmall: TextStyle(fontSize: 12),

  // Text inside buttons and controls (ElevatedButton, TextButton, Switch)
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  labelMedium: TextStyle(fontSize: 12),
  labelSmall: TextStyle(fontSize: 11),
);
