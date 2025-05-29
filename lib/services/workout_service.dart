import 'package:neofit_mobile/models/workout_program.dart';
import 'package:neofit_mobile/services/api_client.dart';

class WorkoutService {
  Future<List<WorkoutProgram>> fetchAllPrograms() async {
    final response = await ApiClient.dio.get('/workoutprogram');

    final data = response.data as List;
    return data.map((e) => WorkoutProgram.fromJson(e)).toList();
  }
}
