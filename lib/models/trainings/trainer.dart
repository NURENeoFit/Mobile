import 'package:neofit_mobile/models/trainings/workout_program.dart';

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
    trainerId: json['trainer_id'],
    trainerFirstName: json['trainer_first_name'],
    trainerLastName: json['trainer_last_name'],
    trainerPhone: json['trainer_phone'],
    trainerExperience: json['trainer_experience'],
    trainerEmail: json['trainer_email'],
    trainerUsername: json['trainer_username'],
    workoutPrograms: (json['workout_programs'] as List<dynamic>)
        .map((e) => WorkoutProgram.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'trainer_id': trainerId,
    'trainer_first_name': trainerFirstName,
    'trainer_last_name': trainerLastName,
    'trainer_phone': trainerPhone,
    'trainer_experience': trainerExperience,
    'trainer_email': trainerEmail,
    'trainer_username': trainerUsername,
    'workout_programs': workoutPrograms.map((wp) => wp.toJson()).toList(),
  };
}