import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // TODO:: INITIALIZE SECURE STORAGE WITH WEB OPTIONS FOR CHROME SUPPORT
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'task2_internship_auth',
      publicKey: 'auth_vault',
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  // TODO:: SAVE AUTH TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  // TODO:: SAVE REFRESH TOKEN
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: _refreshTokenKey,
      value: token,
    );
  }

  // TODO:: RETRIEVE AUTH TOKEN
  static Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  // TODO:: RETRIEVE REFRESH TOKEN
  static Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: _refreshTokenKey,
    );
  }

  // TODO:: DELETE TOKENS (FOR LOGOUT)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // TODO:: DELETE ALL TOKENS (LOGOUT)
  static Future<void> deleteTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // TODO:: CHECK IF USER IS AUTHENTICATED
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
