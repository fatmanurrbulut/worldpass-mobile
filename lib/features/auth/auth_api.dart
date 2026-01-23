import 'api_client.dart';

class AuthApi {
  final ApiClient _client;
  AuthApi(this._client);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.postJson(
      "/api/user/login",
      body: {
        "email": email,
        "password": password,
      },
    );
    return res;
  }
}
