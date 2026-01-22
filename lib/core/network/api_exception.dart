class ApiException implements Exception {
  final int status;
  final String message;
  final dynamic body;

  ApiException(this.status, this.message, {this.body});

  @override
  String toString() => "ApiException($status): $message";
}
