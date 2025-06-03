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
