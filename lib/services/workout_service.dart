import 'package:dio/dio.dart';
import 'package:neofit_mobile/models/trainer.dart';

class TrainerService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api'));

  Future<List<Trainer>> fetchTrainersWithProgramsAndExercises() async {
    // Temporary test data (while backend is not available)
    return [
      Trainer.fromJson({
        'trainerId': 1,
        'trainerFirstName': 'Anna',
        'trainerLastName': 'Ivanova',
        'trainerPhone': '123-456-7890',
        'trainerExperience': 5,
        'trainerEmail': 'anna.ivanova@example.com',
        'trainerUsername': 'anna123',
        'workoutPrograms': [
          {
            'id': 1,
            'name': 'Morning Cardio',
            'trainerId': 1,
            'goalId': 1,
            'duration': 30,
            'programType': 'Cardio',
            'exercises': [
              {
                'id': 1,
                'name': 'Running',
                'duration': 20,
                'burnedCalories': 200,
              },
              {
                'id': 2,
                'name': 'Jumping Jacks',
                'duration': 10,
                'burnedCalories': 100,
              }
            ],
          },
          {
            'id': 2,
            'name': 'Strength Training',
            'trainerId': 1,
            'goalId': 2,
            'duration': 45,
            'programType': 'Strength',
            'exercises': [
              {
                'id': 3,
                'name': 'Push-ups',
                'duration': 10,
                'burnedCalories': 50,
              },
              {
                'id': 4,
                'name': 'Squats',
                'duration': 15,
                'burnedCalories': 80,
              }
            ],
          },
        ],
      }),
      Trainer.fromJson({
        'trainerId': 2,
        'trainerFirstName': 'Ivan',
        'trainerLastName': 'Smirnov',
        'trainerPhone': '234-567-8901',
        'trainerExperience': 6,
        'trainerEmail': 'ivan.smirnov@example.com',
        'trainerUsername': 'ivan456',
        'workoutPrograms': [
          {
            'id': 3,
            'name': 'Evening Yoga',
            'trainerId': 2,
            'goalId': 3,
            'duration': 60,
            'programType': 'Yoga',
            'exercises': [
              {
                'id': 5,
                'name': 'Downward Dog',
                'duration': 15,
                'burnedCalories': 40,
              },
              {
                'id': 6,
                'name': 'Sun Salutation',
                'duration': 20,
                'burnedCalories': 60,
              }
            ],
          },
          {
            'id': 4,
            'name': 'Functional HIIT',
            'trainerId': 2,
            'goalId': 4,
            'duration': 30,
            'programType': 'HIIT',
            'exercises': [
              {
                'id': 7,
                'name': 'Burpees',
                'duration': 10,
                'burnedCalories': 120,
              },
              {
                'id': 8,
                'name': 'Mountain Climbers',
                'duration': 10,
                'burnedCalories': 110,
              }
            ],
          },
        ],
      }),
      Trainer.fromJson({
        'trainerId': 3,
        'trainerFirstName': 'Olga',
        'trainerLastName': 'Petrova',
        'trainerPhone': '345-678-9012',
        'trainerExperience': 7,
        'trainerEmail': 'olga.petrova@example.com',
        'trainerUsername': 'olga789',
        'workoutPrograms': [
          {
            'id': 5,
            'name': 'Stretching & Flexibility',
            'trainerId': 3,
            'goalId': 5,
            'duration': 45,
            'programType': 'Stretching',
            'exercises': [
              {
                'id': 9,
                'name': 'Forward Bend',
                'duration': 15,
                'burnedCalories': 30,
              },
              {
                'id': 10,
                'name': 'Cat-Cow Stretch',
                'duration': 15,
                'burnedCalories': 20,
              }
            ],
          },
          {
            'id': 6,
            'name': 'Pilates Core',
            'trainerId': 3,
            'goalId': 6,
            'duration': 50,
            'programType': 'Pilates',
            'exercises': [
              {
                'id': 11,
                'name': 'Plank',
                'duration': 20,
                'burnedCalories': 60,
              },
              {
                'id': 12,
                'name': 'Leg Raises',
                'duration': 15,
                'burnedCalories': 70,
              }
            ],
          },
        ],
      }),
      Trainer.fromJson({
        'trainerId': 4,
        'trainerFirstName': 'Max',
        'trainerLastName': 'Kravtsov',
        'trainerPhone': '456-789-0123',
        'trainerExperience': 8,
        'trainerEmail': 'max.kravtsov@example.com',
        'trainerUsername': 'max123',
        'workoutPrograms': [
          {
            'id': 7,
            'name': 'Boxing Basics',
            'trainerId': 4,
            'goalId': 7,
            'duration': 40,
            'programType': 'Boxing',
            'exercises': [
              {
                'id': 13,
                'name': 'Jab',
                'duration': 10,
                'burnedCalories': 70,
              },
              {
                'id': 14,
                'name': 'Cross',
                'duration': 10,
                'burnedCalories': 90,
              }
            ],
          },
          {
            'id': 8,
            'name': 'Tabata Blast',
            'trainerId': 4,
            'goalId': 8,
            'duration': 30,
            'programType': 'HIIT',
            'exercises': [
              {
                'id': 15,
                'name': 'Jump Squats',
                'duration': 10,
                'burnedCalories': 110,
              },
              {
                'id': 16,
                'name': 'Burpees',
                'duration': 10,
                'burnedCalories': 120,
              }
            ],
          },
        ],
      }),
    ];

    // Real request (uncomment when backend is ready)
    /*
     try {
       final response = await _dio.get('/trainer_with_programs_and_exercises');

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
       return [];
     }
     */
  }
}

