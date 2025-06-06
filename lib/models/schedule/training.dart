class Training {
  final String specializationName;
  final String fitnessRoomName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String fullNameTrainer;

  const Training({
    required this.specializationName,
    required this.fitnessRoomName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.fullNameTrainer,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['date_of_day'] ?? '');
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return Training(
      specializationName: json['specialization_name'] ?? '',
      fitnessRoomName: json['fitness_room_name'] ?? '',
      date: parsedDate,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      fullNameTrainer:
      '${json['trainer_first_name'] ?? ''} ${json['trainer_last_name'] ?? ''}'.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
    'specialization_name': specializationName,
    'fitness_room_name': fitnessRoomName,
    'date': date.toIso8601String(),
    'start_time': startTime,
    'end_time': endTime,
    'full_name_trainer': fullNameTrainer,
  };
}
