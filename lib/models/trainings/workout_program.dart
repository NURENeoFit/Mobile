import 'package:neofit_mobile/models/trainings/exercise.dart';
import 'package:flutter/material.dart';

class WorkoutProgram {
  final int workoutProgramId;
  final String name;
  final int trainerId;
  final int duration;
  final String programType;
  final List<Exercise> exercises;
  final String icon;

  WorkoutProgram({
    required this.workoutProgramId,
    required this.name,
    required this.trainerId,
    required this.duration,
    required this.programType,
    required this.exercises,
    required this.icon,
  });

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) => WorkoutProgram(
    workoutProgramId: json['workout_training_id'] ?? 0,
    name: json['program_name'] ?? '',
    trainerId: json['trainer_id'] ?? 0,
    duration: json['duration'] ?? 0,
    programType: json['program_type'] ?? '',
    exercises: (json['exercises'] as List?)
        ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList() ?? <Exercise>[],
    icon: json['icon'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'workout_training_id': workoutProgramId,
    'program_name': name,
    'trainer_id': trainerId,
    'duration': duration,
    'program_type': programType,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'icon': icon,
  };
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