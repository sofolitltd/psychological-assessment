import 'assessment_models.dart';
import 'scoring_engine.dart';

class AssessmentResultBundle {
  final String testId;
  final String testName;
  final Map<String, ScoreResult> scores;
  final Map<int, int> rawResponses;
  final AssessmentTest test;

  const AssessmentResultBundle({
    required this.testId,
    required this.testName,
    required this.scores,
    required this.rawResponses,
    required this.test,
  });

  Map<String, dynamic> toJson() => {
        'testId': testId,
        'testName': testName,
        'scores': scores.map((k, v) => MapEntry(k, v.toJson())),
        'rawResponses': rawResponses.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory AssessmentResultBundle.fromJson(
    Map<String, dynamic> json,
    AssessmentTest test,
  ) =>
      AssessmentResultBundle(
        testId: json['testId'] as String,
        testName: json['testName'] as String,
        scores: (json['scores'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, ScoreResult.fromJson(v as Map<String, dynamic>)),
        ),
        rawResponses: (json['rawResponses'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(int.parse(k), v as int),
        ),
        test: test,
      );
}
