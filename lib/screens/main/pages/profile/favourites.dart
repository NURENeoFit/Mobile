import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourites', style: TextTheme.of(context).headlineLarge)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text('You haven\'t added anything to favourites yet.',
                style: TextTheme.of(context).bodyMedium?.copyWith(color: Colors.grey)
            ),
          ],
        ),
      ),
    );
  }
}
