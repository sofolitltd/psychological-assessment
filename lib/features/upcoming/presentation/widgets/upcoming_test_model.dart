import '../../../assessment/domain/assessment_models.dart';

class UpcomingTestItem {
  final TestListItem test;
  final AssessmentResources resources;

  const UpcomingTestItem({
    required this.test,
    this.resources = const AssessmentResources(),
  });

  factory UpcomingTestItem.fromJson(Map<String, dynamic> json) {
    return UpcomingTestItem(
      test: TestListItem.fromJson(json),
      resources: json['resources'] != null
          ? AssessmentResources.fromJson(json['resources'] as Map<String, dynamic>)
          : const AssessmentResources(),
    );
  }
}
