import 'package:flutter/material.dart';

class AbonnementPage extends StatelessWidget {
  const AbonnementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abonnement')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.card_membership, size: 64, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text('Your current abonnement will appear here.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
