import 'package:flutter/material.dart';

final ThemeData customAppTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF7E57C2),
    onPrimary: Colors.white,
    secondary: Colors.teal, //Color(0xFF4CAF50),
    onSecondary: Colors.white,
    surface: Color(0xFFF8F5FA),
    onSurface: Colors.black87,
    error: Color(0xFFE53935),
    onError: Colors.white,

  ),
  scaffoldBackgroundColor: const Color(0xFFF9F6FC),
  useMaterial3: true,
);


final ThemeData testAppTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

final ThemeData testAppTheme2 = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7E57C2)
    ).copyWith(
      primary: Color(0xFF7E57C2), // Primary brand color used for main buttons, FAB and AppBar.
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

      error: Color(0xFFE53935),
      onError: Colors.white,

      // errorContainer: ,
      // onErrorContainer: ,

      shadow: Colors.black12,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F5FA),
    useMaterial3: true
);
