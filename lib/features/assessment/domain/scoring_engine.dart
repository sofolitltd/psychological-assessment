import 'assessment_models.dart';

// ─── ScoreResult ──────────────────────────────────────────────────────────────

class ScoreResult {
  final int rawScore;
  final int maxScore;
  final String severity;
  final String scale;
  final String? interpretation;
  final String? suggestions;

  const ScoreResult({
    required this.rawScore,
    required this.maxScore,
    required this.severity,
    required this.scale,
    this.interpretation,
    this.suggestions,
  });

  /// Returns a copy enriched with content from a matched [ResultBand].
  ScoreResult withBand(ResultBand band) => ScoreResult(
        rawScore: rawScore,
        maxScore: maxScore,
        severity: band.status,
        scale: scale,
        interpretation: band.interpretation,
        suggestions: band.suggestions,
      );
}

// ─── ResultBand Lookup ────────────────────────────────────────────────────────

ResultBand? lookupBand(int score, List<ResultBand> bands, {String? customStatus}) {
  if (customStatus != null && customStatus.isNotEmpty) {
    try {
      return bands.firstWhere((b) => b.status == customStatus);
    } catch (_) {}
  }
  for (final b in bands) {
    if (score >= b.minScore && score <= b.maxScore) return b;
  }
  return bands.isNotEmpty ? bands.last : null;
}

/// Enriches every ScoreResult using the test's [resultBands] map.
Map<String, ScoreResult> enrichResults(
  Map<String, ScoreResult> results,
  Map<String, List<ResultBand>> resultBands,
) {
  return results.map((scale, result) {
    final bands = resultBands[scale];
    if (bands == null || bands.isEmpty) return MapEntry(scale, result);
    final band = lookupBand(result.rawScore, bands, customStatus: result.severity);
    return MapEntry(scale, band != null ? result.withBand(band) : result);
  });
}

// ─── Abstract Engine ──────────────────────────────────────────────────────────

abstract class ScoringEngine {
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  );
}

// ─── Factory ──────────────────────────────────────────────────────────────────

class ScoringEngineFactory {
  static ScoringEngine forTest(String testId) {
    if (testId.startsWith('love_obsession')) return LoveObsessionScoringEngine();
    if (testId.startsWith('dass21')) return Dass21ScoringEngine();
    if (testId.startsWith('srq20')) return Srq20ScoringEngine();
    if (testId.startsWith('cspt')) return CsptScoringEngine();
    return GenericScoringEngine();
  }
}

// ─── Generic Engine ───────────────────────────────────────────────────────────
/// Handles simple sum scoring, including reversed items.
/// Works for any single-scale or multi-scale test where scores are sums.
class GenericScoringEngine implements ScoringEngine {
  @override
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  ) {
    final totals = <String, int>{};
    final counts = <String, int>{};

    for (final q in questions) {
      // We don't have access to global options here easily unless we pass it, but wait!
      // Actually, we do. maxOptionValue passed in is the global one.
      final qMax = q.options != null && q.options!.isNotEmpty
          ? q.options!.map((o) => o.value).reduce((a, b) => a > b ? a : b)
          : maxOptionValue;

      var val = responses[q.id] ?? 0;
      if (q.reversed) val = qMax - val;
      totals[q.scale] = (totals[q.scale] ?? 0) + val;
      
      // We calculate max possible score dynamically now
      final currentMax = counts[q.scale] ?? 0;
      counts[q.scale] = currentMax + qMax;
    }

    return totals.map((scale, total) {
      final scaleMax = counts[scale] ?? 0;
      return MapEntry(
        scale,
        ScoreResult(
          rawScore: total,
          maxScore: scaleMax,
          severity: '',
          scale: scale,
        ),
      );
    });
  }
}

// ─── DASS-21 Engine ───────────────────────────────────────────────────────────
/// Separates questions by scale, multiplies by 2 for DASS-42 equivalents.
class Dass21ScoringEngine implements ScoringEngine {
  @override
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  ) {
    int d = 0, a = 0, s = 0;
    for (final q in questions) {
      final v = responses[q.id] ?? 0;
      switch (q.scale) {
        case 'depression':
          d += v;
        case 'anxiety':
          a += v;
        case 'stress':
          s += v;
      }
    }
    return {
      'depression':
          ScoreResult(rawScore: d * 2, maxScore: 42, severity: '', scale: 'depression'),
      'anxiety':
          ScoreResult(rawScore: a * 2, maxScore: 42, severity: '', scale: 'anxiety'),
      'stress':
          ScoreResult(rawScore: s * 2, maxScore: 42, severity: '', scale: 'stress'),
    };
  }
}

// ─── SRQ-20 Engine ────────────────────────────────────────────────────────────
class Srq20ScoringEngine implements ScoringEngine {
  @override
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  ) {
    final total = responses.values.fold(0, (s, v) => s + v);
    return {
      'general': ScoreResult(
        rawScore: total,
        maxScore: questions.length,
        severity: '',
        scale: 'general',
      ),
    };
  }
}

// ─── C-SSRS Engine ────────────────────────────────────────────────────────────
/// Pattern-based, not a simple sum. Risk level determined by Yes/No pattern.
class CsptScoringEngine implements ScoringEngine {
  @override
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  ) {
    bool yes(int id) => responses[id] == 1;
    int raw;
    if (yes(4) || yes(5) || (yes(6) && yes(7))) {
      raw = 3; // High Risk
    } else if (yes(2) && yes(3)) {
      raw = 2; // Moderate Risk
    } else if (yes(1) || yes(2)) {
      raw = 1; // Low Risk
    } else {
      raw = 0; // No Risk
    }
    return {
      'suicide_risk': ScoreResult(
        rawScore: raw,
        maxScore: 3,
        severity: '',
        scale: 'suicide_risk',
      ),
    };
  }
}

// ─── Love Obsession Engine ────────────────────────────────────────────────────
class LoveObsessionScoringEngine implements ScoringEngine {
  @override
  Map<String, ScoreResult> calculate(
    Map<int, int> responses,
    List<TestQuestion> questions,
    int maxOptionValue,
  ) {
    final total = responses.values.fold(0, (s, v) => s + v);
    String severityOverride = '';

    if (total > 6) {
      if (responses[12] == 1 || responses[13] == 1) {
        severityOverride = 'Excessive Love Obsession';
      } else {
        severityOverride = 'Love Obsession';
      }
    } else {
      severityOverride = 'No Love Obsession';
    }

    return {
      'general': ScoreResult(
        rawScore: total,
        maxScore: questions.length,
        severity: severityOverride,
        scale: 'general',
      ),
    };
  }
}
