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
}
