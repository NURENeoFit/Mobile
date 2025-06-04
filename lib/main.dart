import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/design/theme.dart';
import 'package:neofit_mobile/router.dart';
import 'package:neofit_mobile/utils/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStorage.loadToken();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
