import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class UserApi {
  final ApiClient _api;
  UserApi(this._api);

  Future<dynamic> getProfileRaw() {
    return _api.get<dynamic>(ApiEndpoints.userProfile);
  }

  Future<dynamic> listVcsRaw() {
    return _api.get<dynamic>(ApiEndpoints.userVcs);
  }
}
