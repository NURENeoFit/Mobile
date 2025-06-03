import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/membership/membership.dart';
import 'package:neofit_mobile/services/membership_service.dart';

final membershipNotifierProvider =
AsyncNotifierProvider<MembershipNotifier, Membership?>(
  MembershipNotifier.new,
);

class MembershipNotifier extends AsyncNotifier<Membership?> {
  @override
  Future<Membership?> build() async {
    return await MembershipService().fetchMembershipForUser();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await MembershipService().fetchMembershipForUser();
    state = AsyncData(data);
  }
}