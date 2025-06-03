import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:neofit_mobile/models/workout.dart';
import 'package:neofit_mobile/screens/main/pages/trainings/trainings.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Workout> allWorkouts = [];
  List<Workout> favouriteWorkouts = [];
  List<Workout> filteredWorkouts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorite_workouts') ?? [];

    // TODO: Replace with download from server or provider
    allWorkouts = [
      Workout(id: '1', name: 'Morning Cardio', coach: 'Coach: Anna Ivanova', icon: 'directions_run'),
      Workout(id: '2', name: 'Strength Training', coach: 'Coach: Ivan Smirnov', icon: 'fitness_center'),
      Workout(id: '3', name: 'Evening Yoga', coach: 'Coach: Olga Petrova', icon: 'self_improvement'),
      Workout(id: '4', name: 'Functional HIIT', coach: 'Coach: Max Kravtsov', icon: 'sports'),
      Workout(id: '5', name: 'Stretching & Flexibility', coach: 'Coach: Nina Sharapova', icon: 'self_improvement'),
      Workout(id: '6', name: 'Boxing Basics', coach: 'Coach: Alex Stone', icon: 'sports_martial_arts'),
      Workout(id: '7', name: 'Pilates Core', coach: 'Coach: Elena Markova', icon: 'accessibility_new'),
      Workout(id: '8', name: 'Tabata Blast', coach: 'Coach: John Brooks', icon: 'fitness_center'),
      Workout(id: '9', name: 'Zumba Energy', coach: 'Coach: Karina Lopez', icon: 'music_note'),
      Workout(id: '10', name: 'CrossFit Starter', coach: 'Coach: Dmytro Sydorenko', icon: 'directions_run'),
      Workout(id: '11', name: 'Bodyweight Circuit', coach: 'Coach: Vitalii Romanov', icon: 'fitness_center'),
      Workout(id: '12', name: 'Balance & Mobility', coach: 'Coach: Sofia Kuznetsova', icon: 'accessibility'),
    ];

    favouriteWorkouts = allWorkouts.where((w) => favIds.contains(w.id)).toList();
    filteredWorkouts = favouriteWorkouts;

    setState(() {});
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredWorkouts = favouriteWorkouts.where((item) {
        return item.name.toLowerCase().contains(searchQuery) ||
            item.coach.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  Widget _buildWorkoutTile(Workout item) {
    // final iconData = iconMap[item.icon] ?? Icons.fitness_center;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: ColorScheme.of(context).surface,
        child: ListTile(
          splashColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: ColorScheme.of(context).primaryContainer,
            // child: Icon(iconData, color: ColorScheme.of(context).onPrimaryContainer),
          ),
          title: Text(item.name, style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
          subtitle: Text(item.coach, style: TextTheme.of(context).bodySmall),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            await context.push('/training/${item.id}', extra: item);
            _loadFavourites(); // We will update the favorites after returning
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFavourites = favouriteWorkouts.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites', style: TextTheme.of(context).headlineMedium),
      ),
      body: hasFavourites
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search favourites...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: filteredWorkouts.isEmpty
                ? Center(
              child: Text(
                'No matches found',
                style: TextTheme.of(context).bodyLarge,
              ),
            )
                : ListView.builder(
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                return _buildWorkoutTile(filteredWorkouts[index]);
              },
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'You haven\'t added anything to favourites yet.',
              style: TextTheme.of(context).bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
