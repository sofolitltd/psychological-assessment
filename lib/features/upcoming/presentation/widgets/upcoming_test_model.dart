import '../../../assessment/domain/assessment_models.dart';

class UpcomingTestItem {
  final TestListItem test;
  final String pdfUrl;
  final String scoringGuideUrl;

  const UpcomingTestItem({
    required this.test,
    this.pdfUrl = '',
    this.scoringGuideUrl = '',
  });

  factory UpcomingTestItem.fromJson(Map<String, dynamic> json) {
    return UpcomingTestItem(
      test: TestListItem.fromJson(json),
      pdfUrl: json['pdfUrl'] as String? ?? '',
      scoringGuideUrl: json['scoringGuideUrl'] as String? ?? '',
    );
  }
}
