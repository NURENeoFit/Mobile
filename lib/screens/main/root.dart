import 'package:flutter/material.dart';

import 'package:neofit_mobile/screens/main/pages/home.dart';
import 'package:neofit_mobile/screens/main/pages/calories.dart';
import 'package:neofit_mobile/screens/main/pages/trainings.dart';
import 'package:neofit_mobile/screens/main/pages/profile.dart';
import 'package:neofit_mobile/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CaloriesPage(),
    TrainingsPage(),
    ProfilePage(),
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
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
