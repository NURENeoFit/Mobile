import 'package:flutter/material.dart';

class CaloriesPage extends StatelessWidget {
  const CaloriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.local_fire_department, size: 48, color: Colors.deepOrange),
          SizedBox(height: 16),
          Text('Calories Tracker', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text('Track your daily burned and eaten calories', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
