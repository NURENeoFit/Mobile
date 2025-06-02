import 'package:flutter/material.dart';
import 'package:neofit_mobile/screens/main/pages/home.dart';
import 'package:neofit_mobile/screens/main/pages/profile/profile.dart';
import 'package:neofit_mobile/screens/main/pages/calories.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/trainings.dart';
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

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _ScreenConfig(
        appBar: AppBar(
          title: Text(
            'NeoFit',
            style: TextTheme.of(context).headlineMedium,
          ),
        ),
        body: const HomePage(),
      ),
      _ScreenConfig(
        appBar: AppBar(
          title: Text(
            'Calculate Calories',
            style: TextTheme.of(context).headlineMedium,
          ),
          centerTitle: true,
        ),
        body: const CaloriesPage(),
      ),
      _ScreenConfig(
        appBar: AppBar(
          title: Text(
            'Trainings',
            style: TextTheme.of(context).headlineMedium,
          ),
        ),
        body: const TrainingsPage(),
      ),
      _ScreenConfig(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextTheme.of(context).headlineMedium,
          ),
        ),
        body: const ProfilePage(),
      ),
    ];

    final current = screens[_selectedIndex];

    return Scaffold(
      backgroundColor: current.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
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
