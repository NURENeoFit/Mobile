import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neofit_mobile/models/trainings/trainer.dart';
import 'package:neofit_mobile/models/trainings/workout_program.dart';
import 'package:neofit_mobile/providers/workout_provider.dart';

class TrainingsPage extends ConsumerStatefulWidget {
  const TrainingsPage({super.key});

  @override
  ConsumerState<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends ConsumerState<TrainingsPage> {
  List<Trainer> allTrainers = [];
  List<Trainer> filteredTrainers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trainerNotifierProvider.notifier).refresh();
    });
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase().trim();

      filteredTrainers = allTrainers.where((trainer) {
        final firstName = trainer.trainerFirstName.toLowerCase();
        final lastName = trainer.trainerLastName.toLowerCase();
        final fullName = '$firstName $lastName';
        final reversedFullName = '$lastName $firstName';

        final matchesTrainer = fullName.contains(searchQuery) ||
            reversedFullName.contains(searchQuery) ||
            firstName.contains(searchQuery) ||
            lastName.contains(searchQuery);

        final matchesProgram = trainer.workoutPrograms.any(
                (program) => program.name.toLowerCase().contains(searchQuery));

        return matchesTrainer || matchesProgram;
      }).toList();
    });
  }

  Widget _buildTrainerProgramCard(Trainer trainer, WorkoutProgram program) {
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
          title: Text(
            program.name,
            style: TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Coach: ${trainer.trainerFirstName} ${trainer.trainerLastName}',
            style: TextTheme.of(context).bodySmall,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              iconData,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            context.push(
              '/program_detail',
              extra: {
                'workoutProgram': program,
                'trainer': trainer,
              },
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainerState = ref.watch(trainerNotifierProvider);

    return trainerState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (trainers) {
        allTrainers = trainers;

        filteredTrainers = searchQuery.isEmpty
            ? allTrainers
            : allTrainers.where((trainer) {
          final firstName = trainer.trainerFirstName.toLowerCase();
          final lastName = trainer.trainerLastName.toLowerCase();
          final fullName = '$firstName $lastName';
          final reversedFullName = '$lastName $firstName';

          final matchesTrainer = fullName.contains(searchQuery) ||
              reversedFullName.contains(searchQuery) ||
              firstName.contains(searchQuery) ||
              lastName.contains(searchQuery);

          final matchesProgram = trainer.workoutPrograms.any((program) =>
              program.name.toLowerCase().contains(searchQuery));

          return matchesTrainer || matchesProgram;
        }).toList();

        final hasTrainers = allTrainers.isNotEmpty;

        return SafeArea(
          child: hasTrainers
              ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search trainers or programs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredTrainers.isEmpty
                    ? Center(
                  child: Text(
                    'No results found',
                    style: TextTheme.of(context).bodyLarge,
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredTrainers.length,
                  itemBuilder: (context, index) {
                    final trainer = filteredTrainers[index];

                    final firstName = trainer.trainerFirstName.toLowerCase();
                    final lastName = trainer.trainerLastName.toLowerCase();
                    final fullName = '$firstName $lastName';
                    final reversedFullName = '$lastName $firstName';

                    final isTrainerMatch = fullName.contains(searchQuery) ||
                        reversedFullName.contains(searchQuery) ||
                        firstName.contains(searchQuery) ||
                        lastName.contains(searchQuery);

                    final filteredPrograms = isTrainerMatch
                        ? trainer.workoutPrograms
                        : trainer.workoutPrograms.where((program) =>
                        program.name.toLowerCase().contains(searchQuery)).toList();

                    return Column(
                      children: filteredPrograms
                          .map((program) => _buildTrainerProgramCard(trainer, program))
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 60, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text('Your Trainers', style: TextTheme.of(context).titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Here will be your trainers and their programs',
                  style: TextTheme.of(context).bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
