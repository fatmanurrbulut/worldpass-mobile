import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  String? bearerToken;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    // path her zaman "/api/..." gibi gelsin
    final normalized = path.startsWith("/") ? path : "/$path";
    return Uri.parse("${AppConfig.baseUrl}$normalized").replace(queryParameters: query);
  }

  Map<String, String> _headers({bool json = true}) {
    final h = <String, String>{
      if (json) "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final t = bearerToken;
    if (t != null && t.isNotEmpty) h["Authorization"] = "Bearer $t";
    return h;
  }

  Future<T> postJson<T>(
    String path, {
    Object? body,
    T Function(dynamic json)? parser,
  }) async {
    final res = await _http.post(
      _uri(path),
      headers: _headers(json: true),
      body: jsonEncode(body ?? {}),
    );

    final text = res.body;
    dynamic decoded;
    try {
      decoded = text.isEmpty ? null : jsonDecode(text);
    } catch (_) {
      decoded = text;
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(res.statusCode, "HTTP ${res.statusCode}", body: decoded);
    }

    if (parser != null) return parser(decoded);
    return decoded as T;
  }
}
