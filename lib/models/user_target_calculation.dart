class UserTargetCalculation {
  final int calculatedNormalCalories;
  final double calculatedWeight;
  final DateTime calculatedTargetDate;

  UserTargetCalculation({
    required this.calculatedNormalCalories,
    required this.calculatedWeight,
    required this.calculatedTargetDate,
  });

  factory UserTargetCalculation.fromJson(Map<String, dynamic> json) =>
      UserTargetCalculation(
        calculatedNormalCalories: json['calculated_normal_calories'],
        calculatedWeight: (json['calculated_weight'] as num).toDouble(),
        calculatedTargetDate: DateTime.parse(json['calculated_target_date']),
      );

  Map<String, dynamic> toJson() => {
    'calculated_normal_calories': calculatedNormalCalories,
    'calculated_weight': calculatedWeight,
    'calculated_target_date': calculatedTargetDate.toIso8601String(),
  };
}
