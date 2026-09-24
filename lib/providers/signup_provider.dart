import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/strings.dart';
import '../api/auth_api.dart';

class SignupState {
  final bool isLoading;
  final String? firstNameError;
  final String? lastNameError;
  final String? usernameError;
  final String? passwordError;

  const SignupState({
    this.isLoading = false,
    this.firstNameError,
    this.lastNameError,
    this.usernameError,
    this.passwordError,
  });

  SignupState copyWith({
    bool? isLoading,
    String? firstNameError,
    String? lastNameError,
    String? usernameError,
    String? passwordError,
    bool clearFirstNameError = false,
    bool clearLastNameError = false,
    bool clearUsernameError = false,
    bool clearPasswordError = false,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,

      firstNameError: clearFirstNameError
          ? null
          : firstNameError ?? this.firstNameError,

      lastNameError: clearLastNameError
          ? null
          : lastNameError ?? this.lastNameError,

      usernameError: clearUsernameError
          ? null
          : usernameError ?? this.usernameError,

      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
    );
  }

  bool get hasError {
    return firstNameError != null ||
        lastNameError != null ||
        usernameError != null ||
        passwordError != null;
  }
}

class SignupNotifier extends Notifier<SignupState> {
  @override
  SignupState build() {
    return const SignupState();
  }

  // TODO: VALIDATE FIRST NAME

  void validateFirstName(String firstName) {
    if (firstName.trim().isEmpty) {
      state = state.copyWith(
        firstNameError: 'First name is required',
      );
    } else {
      state = state.copyWith(
        clearFirstNameError: true,
      );
    }
  }

  // TODO: VALIDATE LAST NAME

  void validateLastName(String lastName) {
    if (lastName.trim().isEmpty) {
      state = state.copyWith(
        lastNameError: 'Last name is required',
      );
    } else {
      state = state.copyWith(
        clearLastNameError: true,
      );
    }
  }

  // TODO: VALIDATE USERNAME

  void validateUsername(String username) {
    if (username.trim().isEmpty) {
      state = state.copyWith(
        usernameError: AppStrings.userNameRequired,
      );
    } else {
      state = state.copyWith(
        clearUsernameError: true,
      );
    }
  }

  // TODO: VALIDATE PASSWORD

  void validatePassword(String password) {
    if (password.isEmpty) {
      state = state.copyWith(
        passwordError: AppStrings.passwordRequired,
      );
    } else if (password.length < 6) {
      state = state.copyWith(
        passwordError: AppStrings.passwordMinLength,
      );
    } else {
      state = state.copyWith(
        clearPasswordError: true,
      );
    }
  }

  // TODO: CLEAR FIRST NAME ERROR

  void clearFirstNameError() {
    state = state.copyWith(
      clearFirstNameError: true,
    );
  }

  // TODO: CLEAR LAST NAME ERROR

  void clearLastNameError() {
    state = state.copyWith(
      clearLastNameError: true,
    );
  }

  // TODO: CLEAR USERNAME ERROR

  void clearUsernameError() {
    state = state.copyWith(
      clearUsernameError: true,
    );
  }

  // TODO: CLEAR PASSWORD REQUIRED ERROR

  void clearPasswordRequiredError() {
    if (state.passwordError == AppStrings.passwordRequired) {
      state = state.copyWith(
        clearPasswordError: true,
      );
    }
  }

  // TODO: SIGNUP API

  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
    );

    try {
      final result = await AuthApi.signup(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        username: username.trim(),
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );

      rethrow;
    }
  }
}

// TODO: SIGNUP PROVIDER

final signupProvider =
NotifierProvider<SignupNotifier, SignupState>(
  SignupNotifier.new,
);