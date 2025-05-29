import 'package:flutter/material.dart';

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  final List<Map<String, String>> allExercises = [
    {
      'name': 'Morning Cardio',
      'coach': 'Coach: Anna Ivanova',
      'icon': 'directions_run',
    },
    {
      'name': 'Strength Training',
      'coach': 'Coach: Ivan Smirnov',
      'icon': 'fitness_center',
    },
    {
      'name': 'Evening Yoga',
      'coach': 'Coach: Olga Petrova',
      'icon': 'self_improvement',
    },
    {
      'name': 'Functional HIIT',
      'coach': 'Coach: Max Kravtsov',
      'icon': 'sports',
    },
    {
      'name': 'Stretching & Flexibility',
      'coach': 'Coach: Nina Sharapova',
      'icon': 'self_improvement',
    },
    {
      'name': 'Boxing Basics',
      'coach': 'Coach: Alex Stone',
      'icon': 'sports_martial_arts',
    },
    {
      'name': 'Pilates Core',
      'coach': 'Coach: Elena Markova',
      'icon': 'accessibility_new',
    },
    {
      'name': 'Tabata Blast',
      'coach': 'Coach: John Brooks',
      'icon': 'fitness_center',
    },
    {
      'name': 'Zumba Energy',
      'coach': 'Coach: Karina Lopez',
      'icon': 'music_note',
    },
    {
      'name': 'CrossFit Starter',
      'coach': 'Coach: Dmytro Sydorenko',
      'icon': 'directions_run',
    },
    {
      'name': 'Bodyweight Circuit',
      'coach': 'Coach: Vitalii Romanov',
      'icon': 'fitness_center',
    },
    {
      'name': 'Balance & Mobility',
      'coach': 'Coach: Sofia Kuznetsova',
      'icon': 'accessibility',
    },
  ];

  List<Map<String, String>> filteredExercises = [];
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
        final name = item['name']?.toLowerCase() ?? '';
        final coach = item['coach']?.toLowerCase() ?? '';
        return name.contains(searchQuery) || coach.contains(searchQuery);
      }).toList();
    });
  }

  Widget _buildTrainingTile(Map<String, String> item) {
    final iconData = iconMap[item['icon']] ?? Icons.fitness_center;

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
            child: Icon(
              iconData,
              color: ColorScheme.of(context).onPrimaryContainer,
            ),
          ),
          title: Text(
            item['name'] ?? '',
            style: TextTheme.of(context).bodyLarge?.copyWith(
              fontWeight: FontWeight.w500
            ),
          ),
          subtitle: Text(
            item['coach'] ?? '',
            style: TextTheme.of(context).bodySmall,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to training details
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Search Bar
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

          // Filtered List
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return _buildTrainingTile(filteredExercises[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Mapping icon names to Flutter icons
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
