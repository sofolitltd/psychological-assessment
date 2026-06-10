import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/assessment_bundle.dart';
import '../domain/assessment_models.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

final assessmentRepositoryProvider = Provider<AssessmentRepository>(
  (_) => AssessmentRepository(),
);

final testListProvider = FutureProvider<List<TestListItem>>(
  (ref) => ref.read(assessmentRepositoryProvider).getAvailableTests(),
);

final testDetailProvider = FutureProvider.family<AssessmentTest, String>(
  (ref, testId) => ref.read(assessmentRepositoryProvider).loadTest(testId),
);

class ResultBundleNotifier extends Notifier<Map<String, AssessmentResultBundle>> {
  @override
  Map<String, AssessmentResultBundle> build() => {};

  void save(String testId, AssessmentResultBundle bundle) {
    state = {...state, testId: bundle};
  }
}

final resultBundleProvider =
    NotifierProvider<ResultBundleNotifier, Map<String, AssessmentResultBundle>>(
  ResultBundleNotifier.new,
);

// ─── Repository ───────────────────────────────────────────────────────────────

class AssessmentRepository {
  /// Loads the full test (with resultBands) from assets/data/{testId}.json
  Future<AssessmentTest> loadTest(String testId) async {
    final raw = await rootBundle.loadString('assets/data/$testId.json');
    return AssessmentTest.fromJson(
      json.decode(raw) as Map<String, dynamic>,
    );
  }

  /// Loads the test list from assets/data/tests_manifest.json
  Future<List<TestListItem>> getAvailableTests() async {
    final raw = await rootBundle.loadString('assets/data/tests_manifest.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = data['tests'] as List;
    return list
        .map((e) => TestListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
