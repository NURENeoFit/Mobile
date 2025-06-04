import 'package:neofit_mobile/models/user/program_goal.dart';

enum Gender { male, female }
enum ActivityLevel { low, medium, high }

class PersonalUserData {
  final ProgramGoal goal;
  final double weightKg;
  final double heightCm;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;

  PersonalUserData({
    required this.goal,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  factory PersonalUserData.fromJson(Map<String, dynamic> json) => PersonalUserData(
    goal: ProgramGoal.fromJson(json['goal']),
    weightKg: (json['weight_kg'] as num).toDouble(),
    heightCm: (json['height_cm'] as num).toDouble(),
    age: json['age'],
    gender: Gender.values.firstWhere((e) => e.name == json['gender']),
    activityLevel: ActivityLevel.values.firstWhere((e) => e.name == json['activity_level']),
  );

  Map<String, dynamic> toJson() => {
    'goal': goal.toJson(),
    'weight_kg': weightKg,
    'height_cm': heightCm,
    'age': age,
    'gender': gender.name,
    'activity_level': activityLevel.name,
  };
}
