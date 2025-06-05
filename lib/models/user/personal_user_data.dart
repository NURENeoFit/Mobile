import 'package:neofit_mobile/models/user/program_goal.dart';

enum Gender { male, female }
enum ActivityLevel { low, medium, high }

class PersonalUserData {
  final ProgramGoal goal;
  final double weightKg;
  final int heightCm;
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
    goal: json['goal'] != null
        ? ProgramGoal.fromJson(json['goal'] as Map<String, dynamic>)
        : ProgramGoal(goalType: GoalType.generalFitness, description: ''),
    weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
    heightCm: json['height_cm'] ?? 0,
    age: json['age'] ?? 0,
    gender: Gender.values.firstWhere(
          (e) => e.name == (json['gender'] ?? ''),
      orElse: () => Gender.male,
    ),
    activityLevel: ActivityLevel.values.firstWhere(
          (e) => e.name == (json['activity_level'] ?? ''),
      orElse: () => ActivityLevel.low,
    ),
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
