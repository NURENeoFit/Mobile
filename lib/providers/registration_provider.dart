import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/auth_provider.dart';
import 'package:neofit_mobile/services/auth_service.dart';

enum RegistrationStatus { idle, loading, success, error }

class RegistrationState {
  final RegistrationStatus status;
  final String? error;

  RegistrationState({required this.status, this.error});

  RegistrationState copyWith({RegistrationStatus? status, String? error}) =>
      RegistrationState(
        status: status ?? this.status,
        error: error,
      );
}

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final AuthService _authService;
  RegistrationNotifier(this._authService)
      : super(RegistrationState(status: RegistrationStatus.idle));

  Future<void> register({
    required String username,
    required String password,
    required String email,
  }) async {
    state = RegistrationState(status: RegistrationStatus.loading);
    try {
      await _authService.register(
        username: username,
        password: password,
        email: email,
      );
      state = RegistrationState(status: RegistrationStatus.success);
    } catch (e) {
      state = RegistrationState(
        status: RegistrationStatus.error,
        error: e.toString(),
      );
    }
  }
}

final registrationProvider =
StateNotifierProvider<RegistrationNotifier, RegistrationState>(
      (ref) => RegistrationNotifier(ref.watch(authServiceProvider)),
);
