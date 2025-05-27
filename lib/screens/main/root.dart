import 'package:flutter/material.dart';
import 'package:neofit_mobile/screens/main/pages/home.dart';
import 'package:neofit_mobile/screens/main/pages/profile.dart';
import 'package:neofit_mobile/screens/main/pages/calories.dart';
import 'package:neofit_mobile/screens/main/pages/trainings.dart';
import 'package:neofit_mobile/widgets/bottom_nav_bar.dart';

class _ScreenConfig {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? fab;
  final bool showBottomNav;
  final Color? backgroundColor;

  const _ScreenConfig({
    this.appBar,
    required this.body,
    this.fab,
    this.showBottomNav = true,
    this.backgroundColor,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Each screen defines its own UI configuration
  final List<_ScreenConfig> _screens = [
    _ScreenConfig(
      appBar: AppBar(title: const Text('NeoFit')),
      body: HomePage(),
      fab: null,
      showBottomNav: true,
      backgroundColor: const Color(0xFFF8F5FA)
    ),
    _ScreenConfig(
      appBar: null, // no AppBar
      body: CaloriesPage(),
      fab: null,
      showBottomNav: true,
    ),
    _ScreenConfig(
      appBar: null,
      body: TrainingsPage(),
      fab: null,
      showBottomNav: true,
    ),
    _ScreenConfig(
      appBar: AppBar(title: const Text('Profile')),
      body: ProfilePage(),
      fab: null,
      showBottomNav: true,
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _screens[_selectedIndex];

    return Scaffold(
      backgroundColor: current.backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: current.appBar,
      body: current.body,
      floatingActionButton: current.fab,
      bottomNavigationBar: current.showBottomNav
          ? CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      )
          : null,
    );
  }
}
