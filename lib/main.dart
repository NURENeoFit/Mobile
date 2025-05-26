import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:neofit_mobile/screens/login/login_screen.dart';
import 'package:neofit_mobile/screens/register/register_screen.dart';
import 'package:neofit_mobile/screens/home.dart';
import 'package:neofit_mobile/screens/calories.dart';
import 'package:neofit_mobile/screens/trainings.dart';
import 'package:neofit_mobile/screens/profile.dart';

import 'package:neofit_mobile/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeoFit',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CaloriesScreen(),
    TrainingsScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onTap
      )
    );
  }
}
