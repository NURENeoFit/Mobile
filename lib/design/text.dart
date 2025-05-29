import 'package:flutter/material.dart';

final TextTheme customTextTheme = const TextTheme(
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold), // Application: welcome screen, splash, large banners
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700), // AppBar, like H1
  titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), // Section/Card/Block Title //18
  bodyLarge: TextStyle(fontSize: 16), // Main text (paragraphs, signatures, details)
  bodyMedium: TextStyle(fontSize: 14), // Secondary text (for descriptions, dates, system text)
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // Text inside buttons and controls (ElevatedButton, TextButton, Switch)
  labelSmall: TextStyle(fontSize: 11), // Used for small hints, secondary descriptions under icons, etc.
);
