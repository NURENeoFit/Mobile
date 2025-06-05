import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/trainings/trainer.dart';
import 'package:neofit_mobile/models/trainings/workout_program.dart';
import 'package:neofit_mobile/models/trainings/exercise.dart';

//TODO: Change link
class TrainerService {
  final Dio _dio = DioClient.instance;

  Future<List<Trainer>> fetchTrainersWithProgramsAndExercises() async {
    try {
      final trainersResponse = await _dio.get('/trainers');
      final workoutProgramsResponse = await _dio.get('/workout_programs');
      final exercisesResponse = await _dio.get('/exercises');

      if (trainersResponse.statusCode != 200 ||
          workoutProgramsResponse.statusCode != 200 ||
          exercisesResponse.statusCode != 200) {
        throw Exception('Failed to load data');
      }

      final trainersList = trainersResponse.data as List;
      final programsList = workoutProgramsResponse.data as List;
      final exercisesList = exercisesResponse.data as List;

      final Map<int, List<Exercise>> programExercises = {};
      for (final ex in exercisesList) {
        final programId = ex['workout_program_id'];
        if (programId == null) continue;
        programExercises.putIfAbsent(programId, () => []);
        programExercises[programId]!.add(Exercise.fromJson(ex));
      }

      final Map<int, List<WorkoutProgram>> trainerPrograms = {};
      for (final prog in programsList) {
        final trainerId = prog['trainer_id'];
        if (trainerId == null) continue;
        final programId = prog['workout_training_id'];
        final exercises = programExercises[programId] ?? [];
        final program = WorkoutProgram.fromJson({
          ...prog,
          'exercises': exercises.map((e) => e.toJson()).toList(),
        });
        trainerPrograms.putIfAbsent(trainerId, () => []);
        trainerPrograms[trainerId]!.add(program);
      }

      return trainersList.map<Trainer>((tr) {
        final trainerId = tr['trainer_id'];
        final programs = trainerPrograms[trainerId] ?? [];
        return Trainer.fromJson({
          ...tr,
          'workout_programs': programs.map((p) => p.toJson()).toList(),
        });
      }).toList();
    } catch (e) {
      print('Error fetching trainer data: $e');
      return [];
    }
  }
}
