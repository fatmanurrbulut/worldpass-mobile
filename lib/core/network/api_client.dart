import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();
  final http.Client _http;

  // backend convention
  String? token;        // user_token / issuer_token burada set edilecek
  String? walletDid;    // varsa X-Wallet-Did

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith("/") ? path : "/$path";
    return Uri.parse("${AppConfig.baseUrl}$normalized")
        .replace(queryParameters: query);
  }

  Map<String, String> _headers({bool json = true}) {
    final h = <String, String>{
      if (json) "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final t = token;
    if (t != null && t.isNotEmpty) {
      h["X-Token"] = t; // primary
      h["Authorization"] = "Bearer $t"; // fallback (zararı yok)
    }

    final d = walletDid;
    if (d != null && d.isNotEmpty) h["X-Wallet-Did"] = d;

    return h;
  }

  Future<T> getJson<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) async {
    final res = await _http.get(_uri(path, query), headers: _headers(json: false));
    return _handle<T>(res, parser);
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
    return _handle<T>(res, parser);
  }

  T _handle<T>(http.Response res, T Function(dynamic)? parser) {
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
