import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _persist(testId, bundle);
  }

  Future<void> _persist(String testId, AssessmentResultBundle bundle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('result_$testId', json.encode(bundle.toJson()));
  }
}

final resultBundleProvider =
    NotifierProvider<ResultBundleNotifier, Map<String, AssessmentResultBundle>>(
  ResultBundleNotifier.new,
);

// ─── Repository ───────────────────────────────────────────────────────────────

class AssessmentRepository {
  static const Map<String, String> _testCategories = {
    'srq20_bn': 'Screening',
    'cssrs_bn': 'Screening',
    'wellbeing_bn': 'Screening',
    'dass21_bn': 'Mood',
    'phq9_bn': 'Mood',
    'gad7_bn': 'Mood',
    'pss_bn': 'Mood',
    'self_esteem_bn': 'Self',
    'hopelessness_bn': 'Self',
    'social_anxiety_bn': 'Self',
    'satisfaction_life_bn': 'Self',
    'insomnia_bn': 'Sleep',
    'internet_addiction_bn': 'Behavior',
    'love_obsession_bn': 'Behavior',
    'ocd_bn': 'Behavior',
    'nicotine_addiction_bn': 'Behavior',
    'tipi_bn': 'Personality',
    'dark_triad_bn': 'Personality',
  };

  /// Loads the full test (with resultBands) from assets/data/{testId}.json
  Future<AssessmentTest> loadTest(String testId) async {
    final raw = await rootBundle.loadString('assets/data/$testId.json');
    final jsonMap = json.decode(raw) as Map<String, dynamic>;
    final category = _testCategories[testId];
    return AssessmentTest.fromJson(jsonMap, categoryOverride: category);
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
