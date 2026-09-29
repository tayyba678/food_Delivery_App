import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../login_page.dart';
import '../utils/keys.dart';
import 'secure_storage_service.dart';

class AuthService {
  // TODO:: CENTRALIZED LOGOUT LOGIC
  static Future<void> logout(AppDatabase database, {BuildContext? context}) async {
    // 1. Clear secure storage tokens
    await SecureStorageService.deleteTokens();

    // 2. Clear local database tables
    await database.clearDatabase();

    // 3. Navigate back to Login Page and clear navigation stack
    final navState = context != null ? Navigator.of(context) : navigatorKey.currentState;
    
    if (navState != null) {
      navState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
}
