import 'package:flutter/material.dart';
import 'package:neofit_mobile/design/theme.dart';
import 'package:neofit_mobile/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeoFit',
      theme: customAppTheme,
      routerConfig: appRouter,
    );
  }
}
