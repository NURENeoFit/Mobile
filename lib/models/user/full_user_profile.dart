import 'package:neofit_mobile/models/user/program_goal.dart';
import 'package:neofit_mobile/models/user/user.dart';
import 'package:neofit_mobile/models/user/personal_user_data.dart';

class FullUserProfile {
  final User user;
  final PersonalUserData personalData;

  FullUserProfile({
    required this.user,
    required this.personalData,
  });

  factory FullUserProfile.fromJson(Map<String, dynamic> json) => FullUserProfile(
    user: json['user'] != null
        ? User.fromJson(json['user'] as Map<String, dynamic>)
        : User(
      userFirstName: '',
      userLastName: '',
      username: '',
      userPhone: '',
      userEmail: '',
      userDob: DateTime.now(),
    ),
    personalData: json['personal_data'] != null
        ? PersonalUserData.fromJson(json['personal_data'] as Map<String, dynamic>)
        : PersonalUserData(
      goal: ProgramGoal(
        goalType: GoalType.generalFitness,
        description: '',
      ),
      weightKg: 0,
      heightCm: 0,
      age: 0,
      gender: Gender.male,
      activityLevel: ActivityLevel.low,
    ),
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'personal_data': personalData.toJson(),
  };
}
