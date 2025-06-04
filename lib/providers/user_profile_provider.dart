import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/models/user/full_user_profile.dart';
import 'package:neofit_mobile/services/user_profile_service.dart';

final userProfileNotifierProvider =
AsyncNotifierProvider<UserProfileNotifier, FullUserProfile?>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<FullUserProfile?> {
  final _service = UserProfileService();

  @override
  Future<FullUserProfile?> build() async {
    return await _service.fetchUserProfile();
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? dob,
    int? roleId,
  }) async {
    await _service.updateUser(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      dob: dob,
      roleId: roleId,
    );
    await refresh();
  }

  Future<void> updatePersonalUserData({
    int? goalId,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
  }) async {
    await _service.updatePersonalUserData(
      goalId: goalId,
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );
    await refresh();
  }

  Future<void> updateFullProfile({
    // User
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? dob,
    int? roleId,
    // Personal_User_Data
    int? goalId,
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
  }) async {
    state = const AsyncLoading();
    await _service.updateUser(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      dob: dob,
      roleId: roleId,
    );
    await _service.updatePersonalUserData(
      goalId: goalId,
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await _service.fetchUserProfile();
    state = AsyncData(data);
  }
}
