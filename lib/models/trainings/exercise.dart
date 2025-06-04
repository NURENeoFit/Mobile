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
    exerciseId: json['exercise_id'],
    name: json['name'],
    duration: json['duration'],
    burnedCalories: json['burned_calories'],
  );

  Map<String, dynamic> toJson() => {
    'id': exerciseId,
    'name': name,
    'duration': duration,
    'burnedCalories': burnedCalories,
  };
}
