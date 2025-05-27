import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.bar_chart, size: 64, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text('Your progress and statistics will be displayed here.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
