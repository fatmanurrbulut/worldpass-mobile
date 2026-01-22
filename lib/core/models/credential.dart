class Credential {
  final String id;
  final List<String> type;
  final String issuer;
  final String issuanceDate;
  final String? expirationDate;
  final String subjectDid;
  final Map<String, dynamic> rawJson;

  Credential({
    required this.id,
    required this.type,
    required this.issuer,
    required this.issuanceDate,
    required this.expirationDate,
    required this.subjectDid,
    required this.rawJson,
  });
}
