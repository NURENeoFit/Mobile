import 'package:flutter/material.dart';

final ColorScheme customColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF7E57C2)
).copyWith(
  primary: const Color(0xFF7E57C2), // Primary brand color used for main buttons, FAB and AppBar.
  onPrimary: Colors.white,
  // primaryContainer: ,
  // onPrimaryContainer: ,

  secondary: Colors.teal, //Color(0xFF4CAF50), //For Chips
  onSecondary: Colors.white,

  // secondaryContainer: Colors.teal,
  // onSecondaryContainer: ,

  tertiary: Colors.purpleAccent,
  onTertiary: Colors.white,

  surface: Colors.white,
  onSurface: Colors.black87,
  surfaceContainer: Colors.grey.shade100,

  error: const Color(0xFFE53935),
  onError: Colors.white,

  // errorContainer: ,
  // onErrorContainer: ,

  shadow: Colors.black12,
);