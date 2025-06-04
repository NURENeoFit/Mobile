import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/providers/auth_provider.dart';
import 'package:neofit_mobile/services/auth_service.dart';

enum LoginStatus { idle, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? error;

  LoginState({required this.status, this.error});

  LoginState copyWith({LoginStatus? status, String? error}) =>
      LoginState(
        status: status ?? this.status,
        error: error,
      );
}

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthService _authService;
  LoginNotifier(this._authService)
      : super(LoginState(status: LoginStatus.idle));

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = LoginState(status: LoginStatus.loading);
    try {
      await _authService.login(
        username: username,
        password: password,
      );
      state = LoginState(status: LoginStatus.success);
    } catch (e) {
      state = LoginState(
        status: LoginStatus.error,
        error: e.toString(),
      );
    }
  }
}

final loginProvider =
StateNotifierProvider<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(ref.watch(authServiceProvider)),
);
