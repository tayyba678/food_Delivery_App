import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/strings.dart';
import '../api/auth_api.dart';

class LoginState {
  final bool isLoading;
  final String? usernameError;
  final String? passwordError;

  const LoginState({
    this.isLoading = false,
    this.usernameError,
    this.passwordError,
  });

  LoginState copyWith({
    bool? isLoading,
    String? usernameError,
    String? passwordError,
    bool clearUsernameError = false,
    bool clearPasswordError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,

      usernameError: clearUsernameError
          ? null
          : usernameError ?? this.usernameError,

      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
    );
  }
}
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  void validateUsername(String username) {
    if (username.trim().isEmpty) {
      state = const LoginState(
        usernameError: AppStrings.userNameRequired,
      );
    } else {
      state = LoginState(
        isLoading: state.isLoading,
        passwordError: state.passwordError,
      );
    }
  }

  void validatePassword(String password) {
    String? error;

    if (password.isEmpty) {
      error = AppStrings.passwordRequired;
    } else if (password.length < 6) {
      error = AppStrings.passwordMinLength;
    }

    state = LoginState(
      isLoading: state.isLoading,
      usernameError: state.usernameError,
      passwordError: error,
    );
  }
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    state = LoginState(
      isLoading: true,
      usernameError: state.usernameError,
      passwordError: state.passwordError,
    );

    try {
      final result = await AuthApi.login(
        username: username.trim(),
        password: password,
      );

      state = LoginState(
        isLoading: false,
        usernameError: state.usernameError,
        passwordError: state.passwordError,
      );

      return result;
    } catch (e) {
      state = LoginState(
        isLoading: false,
        usernameError: state.usernameError,
        passwordError: state.passwordError,
      );

      rethrow;
    }
  }

}


  final loginProvider =
    NotifierProvider<LoginNotifier, LoginState>(
    LoginNotifier.new,
    );
