import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_green/main.dart';

class AppAuthContext{
  static const _authTokenKey = "auth_token";
  static const _userIdKey = "user_id";
  static const _usernameKey = "username";

  Future<String?> get authToken async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_authTokenKey);
  }

  Future<String?> get userId async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_authTokenKey);
  }

  Future<String?> get username async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final authToken = pref.getString(_authTokenKey);
    return authToken != null && authToken.isNotEmpty;
  }

  static Future<void> login(String? authToken, String? userId, String? username) async {
    if(authToken != null && userId != null && username != null) {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(_authTokenKey, authToken);
      await pref.setString(_userIdKey, userId);
      await pref.setString(_usernameKey, username);
    }
  }

  static Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_authTokenKey);
    await pref.remove(_userIdKey);
    await supabase.auth.signOut();
  }
}