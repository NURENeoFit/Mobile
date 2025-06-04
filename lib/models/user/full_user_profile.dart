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
    user: User.fromJson(json['user']),
    personalData: PersonalUserData.fromJson(json['personal_data']),
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'personal_data': personalData.toJson(),
  };
}
