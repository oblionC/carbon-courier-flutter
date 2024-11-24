import 'package:shared_preferences/shared_preferences.dart';

class AppAuthContext{
  static const _authTokenKey = "auth_token";
  static const _userIdKey = "user_id";

  Future<String?> get authToken async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_authTokenKey);
  }

  Future<String?> get userIdasync async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_authTokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final authToken = pref.getString(_authTokenKey);
    return authToken != null && authToken.isNotEmpty;
  }

  static Future<void> login(String? authToken, String? userId) async {
    if(authToken != null && userId != null) {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(_authTokenKey, authToken);
      await pref.setString(_userIdKey, userId);
    }
  }

  static Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_authTokenKey);
    await pref.remove(_userIdKey);
  }
}