import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';
import 'package:neofit_mobile/services/user_profile_service.dart';

final userProfileNotifierProvider =
AsyncNotifierProvider<UserProfileNotifier, FullUserProfile?>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<FullUserProfile?> {
  @override
  Future<FullUserProfile?> build() async {
    return await UserProfileService().fetchUserProfile();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await UserProfileService().fetchUserProfile();
    state = AsyncData(data);
  }
}
