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
      usernameError: clearUsernameError ? null : usernameError ?? this.usernameError,
      passwordError: clearPasswordError ? null : passwordError ?? this.passwordError,
    );
  }
}

class LoginNotifier extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  void validateUsername(String username) {
    if (username.trim().isEmpty) {
      state = state.copyWith(usernameError: AppStrings.userNameRequired);
    } else {
      state = state.copyWith(clearUsernameError: true);
    }
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      state = state.copyWith(passwordError: AppStrings.passwordRequired);
    } else if (password.length < 6) {
      state = state.copyWith(passwordError: AppStrings.passwordMinLength);
    } else {
      state = state.copyWith(clearPasswordError: true);
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await AuthApi.login(
        username: username.trim(),
        password: password,
      );
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

final loginProvider = NotifierProvider.autoDispose<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
