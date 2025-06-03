import 'package:flutter/material.dart';

class Training {
  final String specializationName;
  final String fitnessRoomName;
  final DateTime date;
  final TimeOfDay time;
  final String startTime;
  final String endTime;
  final String fullNameTrainer;
  final String type;
  final bool isGroup;

  const Training({
    required this.specializationName,
    required this.fitnessRoomName,
    required this.date,
    required this.time,
    required this.startTime,
    required this.endTime,
    required this.fullNameTrainer,
    required this.type,
    required this.isGroup,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.parse(json['date_of_day']);

    return Training(
      specializationName: json['specialization_name'],
      fitnessRoomName: json['fitness_room_name'],
      date: parsedDate,
      time: TimeOfDay(hour: parsedDate.hour, minute: parsedDate.minute),
      startTime: json['start_time'],
      endTime: json['end_time'],
      fullNameTrainer:
      '${json['trainer_first_name'] ?? ''} ${json['trainer_last_name'] ?? ''}'.trim(),
      type: json['type'],
      isGroup: json['is_group'],
    );
  }

  Map<String, dynamic> toJson() => {
    'specialization_name': specializationName,
    'fitness_room_name': fitnessRoomName,
    'date': date.toIso8601String(),
    'start_time': startTime,
    'end_time': endTime,
    'full_name_trainer': fullNameTrainer,
    'type': type,
    'is_group': isGroup,
  };

  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
