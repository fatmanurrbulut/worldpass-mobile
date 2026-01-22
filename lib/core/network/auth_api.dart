import 'api_client.dart';

class AuthApi {
  AuthApi(this.client);
  final ApiClient client;

  // ✅ Esas fonksiyon
  Future<Map<String, dynamic>> userLogin({
    required String email,
    required String password,
  }) async {
    return client.postJson<Map<String, dynamic>>(
      "/api/user/login",
      body: {
        "email": email,
        "password": password,
      },
      parser: (j) => (j as Map).cast<String, dynamic>(),
    );
  }

  // ✅ LoginScreen eski çağrıyı yapıyorsa derleme için alias
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return userLogin(email: email, password: password);
  }
}
