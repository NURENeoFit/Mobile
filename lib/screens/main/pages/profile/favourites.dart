import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/trainings/trainer.dart';
import 'package:neofit_mobile/models/trainings/workout_program.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/trainings/workout_provider.dart';

class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key});

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  List<WorkoutProgram> favouritePrograms = [];
  List<Trainer> allTrainers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadFavourites);
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favorite_workouts') ?? [];

    final trainers = ref.read(trainerNotifierProvider).maybeWhen(
      data: (data) => data,
      orElse: () => <Trainer>[],
    );

    List<WorkoutProgram> favPrograms = [];
    for (final trainer in trainers) {
      for (final program in trainer.workoutPrograms) {
        if (favIds.contains(program.workoutProgramId.toString())) {
          favPrograms.add(program);
        }
      }
    }

    setState(() {
      allTrainers = trainers;
      favouritePrograms = favPrograms;
    });
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  Trainer? findTrainerByProgram(WorkoutProgram program) {
    return allTrainers.firstWhere(
          (trainer) => trainer.trainerId == program.trainerId,
      orElse: () => Trainer(
        trainerId: -1,
        trainerFirstName: 'Unknown',
        trainerLastName: '',
        trainerPhone: '',
        trainerExperience: 0,
        trainerEmail: '',
        trainerUsername: '',
        workoutPrograms: [],
      ),
    );
  }

  Widget _buildProgramTile(WorkoutProgram program) {
    final trainer = findTrainerByProgram(program);
    final iconData = iconMap[program.icon] ?? Icons.fitness_center;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: Theme.of(context).colorScheme.surface,
        child: ListTile(
          splashColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(iconData, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          title: Text(
            program.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Coach: ${trainer?.trainerFirstName ?? 'Unknown'} ${trainer?.trainerLastName ?? ''}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            if (trainer != null && trainer.trainerId != -1) {
              await context.push(
                '/program_detail',
                extra: {'workoutProgram': program, 'trainer': trainer},
              );
            }
            _loadFavourites();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = favouritePrograms.where((program) {
      final trainer = findTrainerByProgram(program);
      return program.name.toLowerCase().contains(searchQuery) ||
          ('${trainer?.trainerFirstName ?? ''} ${trainer?.trainerLastName ?? ''}').toLowerCase().contains(searchQuery);
    }).toList();

    final hasFavourites = favouritePrograms.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites', style: Theme.of(context).textTheme.headlineMedium),
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
            child: filtered.isEmpty
                ? Center(
              child: Text(
                'No matches found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
                : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return _buildProgramTile(filtered[index]);
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
