class Training {
  final String specializationName;
  final String fitnessRoomName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String fullNameTrainer;
  final bool isGroup;

  const Training({
    required this.specializationName,
    required this.fitnessRoomName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.fullNameTrainer,
    required this.isGroup,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      specializationName: json['specialization_name'] ?? '',
      fitnessRoomName: json['fitness_room_name'] ?? '',
      date: DateTime.parse(json['date_of_day']),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      fullNameTrainer:
      '${json['trainer_first_name'] ?? ''} ${json['trainer_last_name'] ?? ''}'.trim(),
      isGroup: json['is_group'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'specialization_name': specializationName,
    'fitness_room_name': fitnessRoomName,
    'date': date.toIso8601String(),
    'start_time': startTime,
    'end_time': endTime,
    'full_name_trainer': fullNameTrainer,
    'is_group': isGroup,
  };
}
