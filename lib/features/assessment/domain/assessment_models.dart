import 'dart:convert';
import 'dart:ui';

// ─── Attribution ──────────────────────────────────────────────────────────────

class Attribution {
  final String citation;
  final String url;

  const Attribution({required this.citation, this.url = ''});

  factory Attribution.fromJson(Map<String, dynamic> json) => Attribution(
        citation: json['citation'] as String,
        url: json['url'] as String? ?? '',
      );
}

// ─── AssessmentResources ──────────────────────────────────────────────────────

class AssessmentResources {
  final String banglaVersionUrl;
  final String banglaVersionScoringUrl;
  final String banglaVersionDoi;

  const AssessmentResources({
    this.banglaVersionUrl = '',
    this.banglaVersionScoringUrl = '',
    this.banglaVersionDoi = '',
  });

  factory AssessmentResources.fromJson(Map<String, dynamic> json) =>
      AssessmentResources(
        banglaVersionUrl: json['banglaVersionUrl'] as String? ?? '',
        banglaVersionScoringUrl:
            json['banglaVersionScoringUrl'] as String? ?? '',
        banglaVersionDoi: json['banglaVersionDoi'] as String? ?? '',
      );
}

// ─── ResultBand ───────────────────────────────────────────────────────────────

class ResultBand {
  final int minScore;
  final int maxScore;
  final String status;
  final String interpretation;
  final String suggestions;

  const ResultBand({
    required this.minScore,
    required this.maxScore,
    required this.status,
    required this.interpretation,
    required this.suggestions,
  });

  factory ResultBand.fromJson(Map<String, dynamic> json) => ResultBand(
        minScore: json['minScore'] as int,
        maxScore: json['maxScore'] as int,
        status: json['status'] as String,
        interpretation: json['interpretation'] as String? ?? '',
        suggestions: json['suggestions'] as String? ?? '',
      );
}

// ─── TestOption ───────────────────────────────────────────────────────────────

class TestOption {
  final String label;
  final int value;

  const TestOption({required this.label, required this.value});

  factory TestOption.fromJson(Map<String, dynamic> json) => TestOption(
        label: json['label'] as String,
        value: json['value'] as int,
      );
}

// ─── ShowIfCondition ──────────────────────────────────────────────────────────

class ShowIfCondition {
  final int questionId;
  final int value;

  const ShowIfCondition({required this.questionId, required this.value});

  factory ShowIfCondition.fromJson(Map<String, dynamic> json) =>
      ShowIfCondition(
        questionId: json['questionId'] as int,
        value: json['value'] as int,
      );
}

// ─── TestQuestion ─────────────────────────────────────────────────────────────

class TestQuestion {
  final int id;
  final String text;
  final String scale;
  final ShowIfCondition? showIf;
  final List<TestOption>? options;

  /// If true, effective score = (maxOptionValue − selectedValue).
  final bool reversed;

  const TestQuestion({
    required this.id,
    required this.text,
    required this.scale,
    this.showIf,
    this.options,
    this.reversed = false,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    final showIfJson = json['showIf'] as Map<String, dynamic>?;
    return TestQuestion(
      id: json['id'] as int,
      text: json['text'] as String,
      scale: json['scale'] as String? ?? 'general',
      showIf: showIfJson != null ? ShowIfCondition.fromJson(showIfJson) : null,
      options: json['options'] != null
          ? (json['options'] as List)
              .map((o) => TestOption.fromJson(o as Map<String, dynamic>))
              .toList()
          : null,
      reversed: json['reversed'] as bool? ?? false,
    );
  }
}

// ─── AssessmentTest ───────────────────────────────────────────────────────────

class AssessmentTest {
  final String testId;
  final String testName;
  final String? about;
  final List<Attribution>? author;
  final List<Attribution>? adapter;
  final String? category;
  final String? instruction;
  final String? scoringProcedure;
  final AssessmentResources? resources;
  final List<String> scales;
  final List<TestOption> options;
  final List<TestQuestion> questions;

  /// scale name → list of result bands, ordered by minScore ascending.
  final Map<String, List<ResultBand>> resultBands;

  const AssessmentTest({
    required this.testId,
    required this.testName,
    this.about,
    this.author,
    this.adapter,
    this.category,
    this.instruction,
    this.scoringProcedure,
    this.resources,
    required this.scales,
    required this.options,
    required this.questions,
    this.resultBands = const {},
  });

  factory AssessmentTest.fromJson(
    Map<String, dynamic> json, {
    String? categoryOverride,
  }) {
    final rawBands = json['resultBands'] as Map<String, dynamic>? ?? {};
    final bands = rawBands.map((key, value) {
      final list = (value as List)
          .map((b) => ResultBand.fromJson(b as Map<String, dynamic>))
          .toList();
      return MapEntry(key, list);
    });

    return AssessmentTest(
      testId: json['id'] as String,
      testName: json['name'] as String,
      about: json['about'] as String?,
      author: json['author'] != null
          ? (json['author'] as List)
              .map((a) => Attribution.fromJson(a as Map<String, dynamic>))
              .toList()
          : null,
      adapter: json['adapter'] != null
          ? (json['adapter'] as List)
              .map((a) => Attribution.fromJson(a as Map<String, dynamic>))
              .toList()
          : null,
      category: categoryOverride ?? json['category'] as String?,
      instruction: json['instruction'] as String?,
      scoringProcedure: json['scoringProcedure'] as String?,
      resources: json['resources'] != null
          ? AssessmentResources.fromJson(json['resources'] as Map<String, dynamic>)
          : null,
      scales: List<String>.from(json['scales'] as List),
      options: (json['options'] as List)
          .map((o) => TestOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List)
          .map((q) => TestQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      resultBands: bands,
    );
  }

  static AssessmentTest fromJsonString(String s) =>
      AssessmentTest.fromJson(json.decode(s) as Map<String, dynamic>);

  /// Max value across all options — used for reverse scoring.
  int get maxOptionValue => options.isEmpty
      ? 0
      : options.map((o) => o.value).reduce((a, b) => a > b ? a : b);
}

// ─── TestListItem ─────────────────────────────────────────────────────────────
/// Lightweight entry loaded from tests_manifest.json for the list screen.
class TestListItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final int questionCount;
  final int estimatedTimeMinutes;
  final String sensitivityLevel;
  final String reliabilityBadge;
  final String lucideIconName;
  final Color themeColor;
  final String createdAt;

  const TestListItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.questionCount = 0,
    this.estimatedTimeMinutes = 0,
    this.sensitivityLevel = '',
    this.reliabilityBadge = '',
    this.lucideIconName = '',
    this.themeColor = const Color(0xFF4F46E5),
    this.createdAt = '',
  });

  factory TestListItem.fromJson(Map<String, dynamic> json) => TestListItem(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? 'General',
        questionCount: json['questionCount'] as int? ?? 0,
        estimatedTimeMinutes: json['estimatedTimeMinutes'] as int? ?? 0,
        sensitivityLevel: json['sensitivityLevel'] as String? ?? '',
        reliabilityBadge: json['reliabilityBadge'] as String? ?? '',
        lucideIconName: json['lucideIconName'] as String? ?? '',
        themeColor: json['themeColor'] != null
            ? Color(int.parse(
                (json['themeColor'] as String).replaceFirst('#', '0xFF')))
            : const Color(0xFF4F46E5),
        createdAt: json['createdAt'] as String? ?? '',
      );
}
