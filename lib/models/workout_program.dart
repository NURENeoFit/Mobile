import 'package:neofit_mobile/models/exercise.dart';

class WorkoutProgram {
  final int id;
  final String name;
  final int trainerId;
  final int goalId;
  final int duration;
  final String programType;
  final List<Exercise> exercises;

  WorkoutProgram({
    required this.id,
    required this.name,
    required this.trainerId,
    required this.goalId,
    required this.duration,
    required this.programType,
    required this.exercises,
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
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'trainerId': trainerId,
    'goalId': goalId,
    'duration': duration,
    'programType': programType,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };
}
