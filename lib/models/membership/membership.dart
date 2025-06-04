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
    price: (json['membership_price'] as num).toDouble(),
    name: json['membership_name'],
    description: json['membership_description'],
    membershipType: MembershipType.values
        .firstWhere((e) => e.name == json['membership_type']),
    countOfTraining: json['count_of_training'],
    type: AmountType.values
        .firstWhere((e) => e.name == json['type']),
    startDate: json['start_date'],
    endDate: json['end_date'],
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
