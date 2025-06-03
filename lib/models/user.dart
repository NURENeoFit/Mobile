enum Gender { male, female }
enum ActivityLevel { low, medium, high }
enum GoalType { weightLoss, muscleGain, endurance, generalFitness }

class User {
  final int userId;
  final String userFirstName;
  final String userLastName;
  final String username;
  final String userPhone;
  final String userEmail;
  final String userHashPassword;
  final int roleId;
  final DateTime userDob;

  User({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.username,
    required this.userPhone,
    required this.userEmail,
    required this.userHashPassword,
    required this.roleId,
    required this.userDob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['user_id'],
    userFirstName: json['user_first_name'],
    userLastName: json['user_last_name'],
    username: json['username'],
    userPhone: json['user_phone'],
    userEmail: json['user_email'],
    userHashPassword: json['user_hash_password'],
    roleId: json['role_id'],
    userDob: DateTime.parse(json['user_dob']),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_first_name': userFirstName,
    'user_last_name': userLastName,
    'username': username,
    'user_phone': userPhone,
    'user_email': userEmail,
    'user_hash_password': userHashPassword,
    'role_id': roleId,
    'user_dob': userDob.toIso8601String(),
  };
}

class ProgramGoal {
  final int goalId;
  final GoalType goalType;
  final String description;

  ProgramGoal({
    required this.goalId,
    required this.goalType,
    required this.description,
  });

  factory ProgramGoal.fromJson(Map<String, dynamic> json) => ProgramGoal(
    goalId: json['goal_id'],
    goalType: GoalType.values.firstWhere((e) => e.name == json['goal_type']),
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'goal_id': goalId,
    'goal_type': goalType.name,
    'description': description,
  };
}

class PersonalUserData {
  final int personalUserDataId;
  final int userId;
  final ProgramGoal goal;
  final double weightKg;
  final double heightCm;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;

  PersonalUserData({
    required this.personalUserDataId,
    required this.userId,
    required this.goal,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  factory PersonalUserData.fromJson(Map<String, dynamic> json) => PersonalUserData(
    personalUserDataId: json['personal_user_data_id'],
    userId: json['user_id'],
    goal: ProgramGoal.fromJson(json['goal']),
    weightKg: (json['weight_kg'] as num).toDouble(),
    heightCm: (json['height_cm'] as num).toDouble(),
    age: json['age'],
    gender: Gender.values.firstWhere((e) => e.name == json['gender']),
    activityLevel: ActivityLevel.values.firstWhere((e) => e.name == json['activity_level']),
  );

  Map<String, dynamic> toJson() => {
    'personal_user_data_id': personalUserDataId,
    'user_id': userId,
    'goal': goal.toJson(),
    'weight_kg': weightKg,
    'height_cm': heightCm,
    'age': age,
    'gender': gender.name,
    'activity_level': activityLevel.name,
  };
}

class FullUserProfile {
  final User user;
  final PersonalUserData personalData;

  FullUserProfile({
    required this.user,
    required this.personalData,
  });

  factory FullUserProfile.fromJson(Map<String, dynamic> json) => FullUserProfile(
    user: User.fromJson(json['user']),
    personalData: PersonalUserData.fromJson(json['personalData']),
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'personalData': personalData.toJson(),
  };
}