import 'package:neofit_mobile/models/exercise.dart';
import 'package:flutter/material.dart';

class WorkoutProgram {
  final int id;
  final String name;
  final int trainerId;
  final int goalId;
  final int duration;
  final String programType;
  final List<Exercise> exercises;
  final String icon;

  WorkoutProgram({
    required this.id,
    required this.name,
    required this.trainerId,
    required this.goalId,
    required this.duration,
    required this.programType,
    required this.exercises,
    required this.icon,
  });

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) => WorkoutProgram(
    id: json['id'],
    name: json['name'],
    trainerId: json['trainerId'],
    goalId: json['goalId'],
    duration: json['duration'],
    programType: json['programType'],
    exercises: (json['exercises'] as List<dynamic>)
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList(),
    icon: json['icon'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'trainerId': trainerId,
    'goalId': goalId,
    'duration': duration,
    'programType': programType,
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
