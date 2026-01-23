import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _kTokenKey = "wp_access_token";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _kTokenKey, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _kTokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _kTokenKey);
  }
}
