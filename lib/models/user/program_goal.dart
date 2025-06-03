enum GoalType { weightLoss, muscleGain, endurance, generalFitness }

class ProgramGoal {
  final int goalId;
  final GoalType goalType;
  final String description;

  ProgramGoal({
    required this.goalId,
    required this.goalType,
    required this.description,
  });

  factory ProgramGoal.fromJson(Map<String, dynamic> json) => ProgramGoal(
    goalId: json['goal_id'],
    goalType: GoalType.values.firstWhere((e) => e.name == json['goal_type']),
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'goal_id': goalId,
    'goal_type': goalType.name,
    'description': description,
  };
}