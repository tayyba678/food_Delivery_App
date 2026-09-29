import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';
import '../utils/strings.dart';
import '../utils/error_handler.dart';

class AuthApi {
  // TODO:: LOGIN
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.https(AppStrings.apiHost, AppStrings.loginPath);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          AppStrings.keyUsername: username,
          AppStrings.keyPassword: password,
        }),
      ).timeout(const Duration(seconds: 10));

      ErrorHandler.handleResponse(response);

      final data = jsonDecode(response.body);
      
      // Save both tokens
      await SecureStorageService.saveToken(data[AppStrings.keyAccessToken]);
      await SecureStorageService.saveRefreshToken(data[AppStrings.keyRefreshToken]);
      
      return data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // TODO:: SIGNUP
  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final url = Uri.https(AppStrings.apiHost, AppStrings.signupPath);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          AppStrings.keyFirstName: firstName,
          AppStrings.keyLastName: lastName,
          AppStrings.keyUsername: username,
          AppStrings.keyPassword: password,
        }),
      ).timeout(const Duration(seconds: 10));

      ErrorHandler.handleResponse(response);

      // Signup successful, now login to get tokens
      return await login(username: username, password: password);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // TODO:: TOKEN REFRESH
  static Future<String?> refreshAccessToken() async {
    final refreshToken = await SecureStorageService.getRefreshToken();
    if (refreshToken == null) return null;

    final url = Uri.https(AppStrings.apiHost, AppStrings.refreshPath);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          AppStrings.keyRefreshToken: refreshToken,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newToken = data[AppStrings.keyAccessToken];
        await SecureStorageService.saveToken(newToken);
        return newToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // TODO:: AUTHENTICATED GET REQUEST WITH AUTO-LOGOUT
  static Future<http.Response> authenticatedGet(Uri url, AppDatabase db) async {
    try {
      String? token = await SecureStorageService.getToken();

      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Handle 401/403 - Attempt Refresh
      if (response.statusCode == 401 || response.statusCode == 403) {
        final newToken = await refreshAccessToken();
        if (newToken != null) {
          response = await http.get(
            url,
            headers: {
              'Authorization': 'Bearer $newToken',
              'Accept': 'application/json',
            },
          ).timeout(const Duration(seconds: 15));
        } else {
          // Refresh failed -> Logout
          await AuthService.logout(db);
          throw AppError(
            message: AppStrings.errorSessionExpired,
            type: ErrorType.sessionExpired,
          );
        }
      }

      ErrorHandler.handleResponse(response);
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
