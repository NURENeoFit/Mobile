enum MembershipType {
  fitness,
  gym,
  gymTrainer
}

enum AmountType {
  individual,
  group,
}

class Membership {
  final double price;
  final String name;
  final String description;
  final MembershipType membershipType;
  final int countOfTraining;
  final AmountType type;
  final String startDate;
  final String endDate;

  Membership({
    required this.price,
    required this.name,
    required this.description,
    required this.membershipType,
    required this.countOfTraining,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    price: (json['membership_price'] ?? 0.0) is num
        ? (json['membership_price'] ?? 0.0).toDouble()
        : double.tryParse(json['membership_price']?.toString() ?? '0') ?? 0.0,
    name: json['membership_name'] ?? '',
    description: json['membership_description'] ?? '',
    membershipType: MembershipType.values.firstWhere(
          (e) => e.name == (json['membership_type'] ?? 'gym'),
      orElse: () => MembershipType.gym,
    ),
    countOfTraining: json['count_of_training'] ?? 0,
    type: AmountType.values.firstWhere(
          (e) => e.name == (json['type'] ?? 'individual'),
      orElse: () => AmountType.individual,
    ),
    startDate: json['start_date'] ?? '',
    endDate: json['end_date'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'membership_price': price,
    'membership_name': name,
    'membership_description': description,
    'membership_type': membershipType.name,
    'count_of_training': countOfTraining,
    'type': type.name,
    'start_date': startDate,
    'end_date': endDate,
  };
}
