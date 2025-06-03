import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/trainer.dart';

class TrainerService {
  final Dio _dio = DioClient.instance;

  Future<List<Trainer>> fetchTrainersWithProgramsAndExercises() async {
     try {
       final response = await _dio.get('/trainers');

       if (response.statusCode == 200 && response.data is List) {
         List<Trainer> trainers = (response.data as List)
             .map((trainerData) => Trainer.fromJson(trainerData as Map<String, dynamic>))
             .toList();
         return trainers;
       } else {
         throw Exception('Failed to load trainer data');
       }
     } catch (e) {
       print('Error fetching trainer data: $e');
     }

     return [];
  }
}
