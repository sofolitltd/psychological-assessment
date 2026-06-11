enum PdfType { full, summary }

class PdfUserInfo {
  final String name;
  final String? clientId;
  final String? phone;
  final PdfType reportType;

  const PdfUserInfo({
    required this.name,
    this.clientId,
    this.phone,
    this.reportType = PdfType.full,
  });
}
