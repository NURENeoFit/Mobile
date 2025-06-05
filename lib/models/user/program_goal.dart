enum GoalType { weightLoss, muscleGain, endurance, generalFitness }

class ProgramGoal {
  final GoalType goalType;
  final String description;

  ProgramGoal({
    required this.goalType,
    required this.description,
  });

  factory ProgramGoal.fromJson(Map<String, dynamic> json) => ProgramGoal(
    goalType: GoalType.values.firstWhere(
          (e) => e.name == (json['goal_type'] ?? ''),
      orElse: () => GoalType.generalFitness,
    ),
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'goal_type': goalType.name,
    'description': description,
  };

  @override
  String toString() {
    switch (this.goalType) {
      case GoalType.weightLoss:
        return 'Weight Loss';
      case GoalType.muscleGain:
        return 'Muscle Gain';
      case GoalType.endurance:
        return 'Endurance';
      case GoalType.generalFitness:
        return 'General Fitness';
    }
  }
}
