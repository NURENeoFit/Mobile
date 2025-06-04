enum MealType { breakfast, lunch, dinner }

class UserMeal {
  final int? id;
  final MealType type;
  final int calories;
  final DateTime createdTime;
  final String? notes;

  UserMeal({
    this.id,
    required this.type,
    required this.calories,
    required this.createdTime,
    this.notes,
  });

  UserMeal copyWith({
    int? id,
    MealType? type,
    int? calories,
    DateTime? createdTime,
    String? notes,
  }) {
    return UserMeal(
      id: id ?? this.id,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      createdTime: createdTime ?? this.createdTime,
      notes: notes ?? this.notes,
    );
  }

  factory UserMeal.fromJson(Map<String, dynamic> json) => UserMeal(
    id: json['id'],
    type: MealType.values.firstWhere((e) => e.name == json['type']),
    calories: json['calories'],
    createdTime: DateTime.parse(json['created_time']),
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'type': type.name,
    'calories': calories,
    'created_time': createdTime.toIso8601String().substring(0, 10),
    if (notes != null) 'notes': notes,
  };
}
