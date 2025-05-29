import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics', style: TextTheme.of(context).headlineMedium)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart, size: 64, color: ColorScheme.of(context).primary),
            SizedBox(height: 16),
            Text('Your progress and statistics will be displayed here.',
                style: TextTheme.of(context).bodyMedium?.copyWith(color: Colors.grey)
            ),
          ],
        ),
      ),
    );
  }
}
