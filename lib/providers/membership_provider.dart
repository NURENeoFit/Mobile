import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/services/membership_service.dart';
import 'package:neofit_mobile/models/membership.dart';

final membershipProvider = FutureProvider<Membership>((ref) async {
  final service = MembershipService();
  return await service.fetchMembershipForUser();
});