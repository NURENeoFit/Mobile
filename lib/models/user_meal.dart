enum MealType { breakfast, lunch, dinner }

class UserMeal {
  final MealType type;
  final int calories;
  final DateTime createdTime;
  final String? notes;

  UserMeal({
    required this.type,
    required this.calories,
    required this.createdTime,
    this.notes,
  });

  factory UserMeal.fromJson(Map<String, dynamic> json) => UserMeal(
    type: MealType.values.firstWhere((e) => e.name == json['type']),
    calories: json['calories'],
    createdTime: DateTime.parse(json['created_time']),
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'calories': calories,
    'created_time': createdTime.toIso8601String(),
    'notes': notes,
  };
}
