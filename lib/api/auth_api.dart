import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/strings.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    // Using Uri.https is more reliable on Web/Chrome than Uri.parse
    final url = Uri.https(AppStrings.apiHost, AppStrings.loginPath);

    final response = await http.post(
      url,
      headers: {
        AppStrings.headerContentType: AppStrings.contentTypeJson,
        AppStrings.headerAccept: AppStrings.acceptJson, // Added to fix the Chrome CORS fetch error
      },
      body: jsonEncode({
        AppStrings.keyUsername: username,
        AppStrings.keyPassword: password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data[AppStrings.keyMessage] ?? AppStrings.loginFailed);
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final url = Uri.https(AppStrings.apiHost, AppStrings.signupPath);

    final response = await http.post(
      url,
      headers: {
        AppStrings.headerContentType: AppStrings.contentTypeJson,
        AppStrings.headerAccept: AppStrings.acceptJson, // Added to fix the Chrome CORS fetch error
      },
      body: jsonEncode({
        AppStrings.keyFirstName: firstName,
        AppStrings.keyLastName: lastName,
        AppStrings.keyUsername: username,
        AppStrings.keyPassword: password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data[AppStrings.keyMessage] ?? AppStrings.signupFailed);
    }
  }
}
