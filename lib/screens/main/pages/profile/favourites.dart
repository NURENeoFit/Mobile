import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text('You haven\'t added anything to favourites yet.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
