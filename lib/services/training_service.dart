import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';

import 'package:neofit_mobile/models/schedule/training.dart';

class TrainingService {
  final Dio _dio = DioClient.instance;

  Future<Map<DateTime, List<Training>>> fetchTrainingsForUserGroupedByDate() async {
    // Temporary test data (while backend is not available)
    final List<Training> trainings = [
      Training(
        specializationName: 'Leg Day',
        fitnessRoomName: 'Room 1',
        date: DateTime.utc(2025, 5, 28),
        time: const TimeOfDay(hour: 9, minute: 30),
        startTime: '09:30',
        endTime: '10:30',
        fullNameTrainer: 'Anna',
        type: 'group',
        isGroup: true,
      ),
      Training(
        specializationName: 'Cardio',
        fitnessRoomName: 'Room 2',
        date: DateTime.utc(2025, 5, 29),
        time: const TimeOfDay(hour: 14, minute: 0),
        startTime: '14:00',
        endTime: '15:00',
        fullNameTrainer: 'Mike',
        type: 'personal',
        isGroup: false,
      ),
      Training(
        specializationName: 'Upper Body',
        fitnessRoomName: 'Room 3',
        date: DateTime.utc(2025, 5, 30),
        time: const TimeOfDay(hour: 11, minute: 0),
        startTime: '11:00',
        endTime: '12:00',
        fullNameTrainer: 'Sara',
        type: 'group',
        isGroup: true,
      ),
      Training(
        specializationName: 'Stretching',
        fitnessRoomName: 'Room 3',
        date: DateTime.utc(2025, 5, 30),
        time: const TimeOfDay(hour: 13, minute: 15),
        startTime: '13:15',
        endTime: '14:00',
        fullNameTrainer: 'Leo',
        type: 'personal',
        isGroup: false,
      ),
    ];

    final Map<DateTime, List<Training>> grouped = {};

    for (final training in trainings) {
      final dateKey = DateTime.utc(
        training.date.year,
        training.date.month,
        training.date.day,
      );

      grouped.putIfAbsent(dateKey, () => []).add(training);
    }

    return grouped;

    // Real request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/trainings');

      if (response.statusCode == 200 && response.data is List) {
        final trainings = (response.data as List)
            .map((e) => Training.fromJson(e))
            .toList();

        final Map<DateTime, List<Training>> grouped = {};

        for (final training in trainings) {
          final dateKey = DateTime.utc(
            training.date.year,
            training.date.month,
            training.date.day,
          );
          grouped.putIfAbsent(dateKey, () => []).add(training);
        }

        return grouped;
      }
    } catch (e) {
      print('Error fetching trainings: $e');
    }

    return {};
    */
  }
}
