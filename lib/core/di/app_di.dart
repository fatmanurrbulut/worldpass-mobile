import '../network/api_client.dart';
import '../network/auth_api.dart';
import '../storage/secure_token_storage.dart';

class AppDI {
  AppDI._();

  static final apiClient = ApiClient();
  static final authApi = AuthApi(apiClient);
  static final tokenStorage = SecureTokenStorage();
}
