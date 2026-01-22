/// lib/core/config/api_config.dart
class ApiConfig {
  ApiConfig._();

  /// Change only this when env changes
  static const String baseUrl = 'https://worldpass-beta.heptapusgroup.com';

  /// Common timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration readTimeout = Duration(seconds: 20);

  /// Default headers
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
