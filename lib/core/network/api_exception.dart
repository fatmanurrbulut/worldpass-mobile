class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic body;

  ApiException(this.statusCode, this.message, {this.body});

  @override
  String toString() => "ApiException($statusCode): $message | body=$body";
}
