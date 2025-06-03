class Exercise {
  final int id;
  final String name;
  final int duration;
  final int burnedCalories;

  Exercise({
    required this.id,
    required this.name,
    required this.duration,
    required this.burnedCalories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'],
    name: json['name'],
    duration: json['duration'],
    burnedCalories: json['burnedCalories'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'duration': duration,
    'burnedCalories': burnedCalories,
  };
}
