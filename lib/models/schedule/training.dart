class Training {
  final String specializationName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String fullNameTrainer;

  const Training({
    required this.specializationName,
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
      date: parsedDate,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      fullNameTrainer:
      '${json['trainer_first_name'] ?? ''} ${json['trainer_last_name'] ?? ''}'.trim(),
    );
  }

  Map<String, dynamic> toJson() => {
    'specialization_name': specializationName,
    'date': date.toIso8601String(),
    'start_time': startTime,
    'end_time': endTime,
    'full_name_trainer': fullNameTrainer,
  };
}
