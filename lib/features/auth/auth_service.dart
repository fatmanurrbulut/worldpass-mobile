import '../../core/network/api_client.dart';
import '../user/user_api.dart';
import 'auth_api.dart';
import 'models/login_req.dart';

class AuthService {
  final ApiClient _api;
  final AuthApi _authApi;
  final UserApi _userApi;

  AuthService(this._api)
      : _authApi = AuthApi(_api),
        _userApi = UserApi(_api);

  /// Login olur, token'ı ApiClient içine set eder, sonra /me (profile) dener.
  Future<void> login({required String email, required String password}) async {
    final token = await _authApi.login(LoginReq(email: email, password: password));
    await _api.setAccessToken(token.accessToken);

    // Token çalışıyor mu hızlı check (opsiyonel ama iyi)
    await _userApi.getProfileRaw();
  }

  Future<void> logout() async {
    await _api.setAccessToken(null);
  }
}
