import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: Stack(
        alignment: Alignment.center,
        children: [
          Text('👤 Profile', style: TextStyle(fontSize: 24)),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Logout'),
              )
            ],
          ),
        ],
      ),
      )
    );
  }
}