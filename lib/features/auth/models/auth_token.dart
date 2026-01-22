class AuthToken {
  final String accessToken;

  AuthToken({required this.accessToken});

  /// Backend farklı isimlerle dönebilir: access_token / accessToken / token
  factory AuthToken.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Invalid token json');
    }

    final t = (json['access_token'] ??
            json['accessToken'] ??
            json['token'] ??
            json['jwt'])
        ?.toString();

    if (t == null || t.isEmpty) {
      throw const FormatException('Token not found in response');
    }

    return AuthToken(accessToken: t);
  }
}
