class Exercise {
  final int exerciseId;
  final String name;
  final int duration;
  final int burnedCalories;

  Exercise({
    required this.exerciseId,
    required this.name,
    required this.duration,
    required this.burnedCalories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    exerciseId: json['exercise_id'] ?? -1,
    name: json['name'] ?? '',
    duration: json['duration'] ?? 0,
    burnedCalories: json['burned_calories'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'exercise_id': exerciseId,
    'name': name,
    'duration': duration,
    'burned_calories': burnedCalories,
  };
}
