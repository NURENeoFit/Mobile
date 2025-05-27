import 'package:flutter/material.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.fitness_center, size: 48, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text('Your Trainings', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text('Here will be your workout plans', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
