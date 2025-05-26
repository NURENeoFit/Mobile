import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.home, size: 48, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text('Home', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text('Welcome to NeoFit!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
