import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssessmentState {
  final Map<int, int> responses;

  const AssessmentState({this.responses = const {}});

  AssessmentState copyWith({Map<int, int>? responses}) {
    return AssessmentState(responses: responses ?? this.responses);
  }
}

class AssessmentNotifier extends Notifier<AssessmentState> {
  @override
  AssessmentState build() => const AssessmentState();

  void setResponse(int questionId, int value) {
    final updated = Map<int, int>.from(state.responses);
    updated[questionId] = value;
    state = state.copyWith(responses: updated);
  }

  void clearResponse(int questionId) {
    final updated = Map<int, int>.from(state.responses)..remove(questionId);
    state = state.copyWith(responses: updated);
  }

  void reset() {
    state = const AssessmentState();
  }

  double getProgress(int visibleCount) {
    if (visibleCount == 0) return 0;
    final answered = state.responses.length;
    return (answered / visibleCount).clamp(0.0, 1.0);
  }

  bool isComplete(int visibleCount) {
    if (visibleCount == 0) return false;
    return state.responses.length >= visibleCount;
  }
}

final assessmentProvider = NotifierProvider<AssessmentNotifier, AssessmentState>(() {
  return AssessmentNotifier();
});
