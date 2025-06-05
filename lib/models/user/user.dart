class User {
  final String userFirstName;
  final String userLastName;
  final String username;
  final String userPhone;
  final String userEmail;
  final DateTime userDob;

  User({
    required this.userFirstName,
    required this.userLastName,
    required this.username,
    required this.userPhone,
    required this.userEmail,
    required this.userDob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userFirstName: json['user_first_name'] ?? '',
    userLastName: json['user_last_name'] ?? '',
    username: json['username'] ?? '',
    userPhone: json['user_phone'] ?? '',
    userEmail: json['user_email'] ?? '',
    userDob: DateTime.parse(json['user_dob']),
  );

  Map<String, dynamic> toJson() => {
    'user_first_name': userFirstName,
    'user_last_name': userLastName,
    'username': username,
    'user_phone': userPhone,
    'user_email': userEmail,
    'user_dob': userDob.toIso8601String(),
  };
}
