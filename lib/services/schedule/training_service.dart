import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';

import 'package:neofit_mobile/models/schedule/training.dart';

class TrainingService {
  final Dio _dio = DioClient.instance;

  Future<Map<DateTime, List<Training>>> fetchTrainingsForUserGroupedByDate() async {
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
  }
}
