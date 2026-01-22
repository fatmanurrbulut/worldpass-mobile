import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _k = "wp_token";

  Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_k, token);
  }

  Future<String?> readToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_k);
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_k);
  }
}
