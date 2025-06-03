class UserTargetCalculation {
  final int userTargetCalculationId;
  final int userId;
  final int calculatedNormalCalories;
  final double calculatedWeight;
  final DateTime calculatedTargetDate;

  UserTargetCalculation({
    required this.userTargetCalculationId,
    required this.userId,
    required this.calculatedNormalCalories,
    required this.calculatedWeight,
    required this.calculatedTargetDate,
  });

  factory UserTargetCalculation.fromJson(Map<String, dynamic> json) =>
      UserTargetCalculation(
        userTargetCalculationId: json['user_target_calculation_id'],
        userId: json['user_id'],
        calculatedNormalCalories: json['calculated_normal_calories'],
        calculatedWeight: (json['calculated_weight'] as num).toDouble(),
        calculatedTargetDate: DateTime.parse(json['calculated_target_date']),
      );

  Map<String, dynamic> toJson() => {
    'user_target_calculation_id': userTargetCalculationId,
    'user_id': userId,
    'calculated_normal_calories': calculatedNormalCalories,
    'calculated_weight': calculatedWeight,
    'calculated_target_date': calculatedTargetDate.toIso8601String(),
  };
}
