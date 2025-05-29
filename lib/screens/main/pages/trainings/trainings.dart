import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/workout.dart';

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  final List<Workout> allExercises = [
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

  List<Workout> filteredExercises = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredExercises = allExercises;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredExercises = allExercises.where((item) {
        return item.name.toLowerCase().contains(searchQuery) ||
            item.coach.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  Widget _buildTrainingTile(Workout item) {
    final iconData = iconMap[item.icon] ?? Icons.fitness_center;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: ColorScheme.of(context).surface,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: ColorScheme.of(context).primaryContainer,
            child: Icon(iconData, color: ColorScheme.of(context).onPrimaryContainer),
          ),
          title: Text(item.name, style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
          subtitle: Text(item.coach, style: TextTheme.of(context).bodySmall),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push('/training/${item.id}', extra: item);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTrainings = allExercises.isNotEmpty;

    return SafeArea(
      child: hasTrainings
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search trainings...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredExercises.isEmpty
                ? Center(
              child: Text(
                'No results found',
                style: TextTheme.of(context).bodyLarge,
              ),
            )
                : ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return _buildTrainingTile(filteredExercises[index]);
              },
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 60, color: ColorScheme.of(context).primary),
            const SizedBox(height: 16),
            Text('Your Trainings', style: TextTheme.of(context).titleLarge),
            const SizedBox(height: 8),
            Text(
              'Here will be your workout plans',
              style: TextTheme.of(context).bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

const Map<String, IconData> iconMap = {
  'fitness_center': Icons.fitness_center,
  'directions_run': Icons.directions_run,
  'self_improvement': Icons.self_improvement,
  'sports': Icons.sports,
  'sports_martial_arts': Icons.sports_martial_arts,
  'accessibility': Icons.accessibility,
  'accessibility_new': Icons.accessibility_new,
  'music_note': Icons.music_note,
};
