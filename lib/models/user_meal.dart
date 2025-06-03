enum MealType { breakfast, lunch, dinner }

class UserMeal {
  MealType type;
  int calories;
  DateTime createdTime;
  String? notes;

  UserMeal({
    required this.type,
    required this.calories,
    required this.createdTime,
    this.notes,
  });

  UserMeal copyWith({
    MealType? type,
    int? calories,
    DateTime? createdTime,
  }) {
    return UserMeal(
      type: type ?? this.type,
      calories: calories ?? this.calories,
      createdTime: createdTime ?? this.createdTime,
    );
  }

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
