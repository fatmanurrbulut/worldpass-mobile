class TokenStore {
  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<void> setAccessToken(String? token) async {
    _accessToken = token;
  }

  Future<void> clear() async {
    _accessToken = null;
  }
}
