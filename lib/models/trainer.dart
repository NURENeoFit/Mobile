import 'package:neofit_mobile/models/workout_program.dart';

class Trainer {
  final int trainerId;
  final String trainerFirstName;
  final String trainerLastName;
  final String trainerPhone;
  final int trainerExperience;
  final String trainerEmail;
  final String trainerUsername;
  final List<WorkoutProgram> workoutPrograms;

  Trainer({
    required this.trainerId,
    required this.trainerFirstName,
    required this.trainerLastName,
    required this.trainerPhone,
    required this.trainerExperience,
    required this.trainerEmail,
    required this.trainerUsername,
    required this.workoutPrograms,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    trainerId: json['trainerId'],
    trainerFirstName: json['trainerFirstName'],
    trainerLastName: json['trainerLastName'],
    trainerPhone: json['trainerPhone'],
    trainerExperience: json['trainerExperience'],
    trainerEmail: json['trainerEmail'],
    trainerUsername: json['trainerUsername'],
    workoutPrograms: (json['workoutPrograms'] as List<dynamic>)
        .map((e) => WorkoutProgram.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'trainerId': trainerId,
    'trainerFirstName': trainerFirstName,
    'trainerLastName': trainerLastName,
    'trainerPhone': trainerPhone,
    'trainerExperience': trainerExperience,
    'trainerEmail': trainerEmail,
    'trainerUsername': trainerUsername,
    'workoutPrograms': workoutPrograms.map((wp) => wp.toJson()).toList(),
  };
}