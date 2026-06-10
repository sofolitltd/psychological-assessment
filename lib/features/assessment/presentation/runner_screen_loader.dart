import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/assessment_repository.dart';
import 'assessment_runner_screen.dart';

class RunnerScreenLoader extends ConsumerWidget {
  final String testId;
  const RunnerScreenLoader({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testAsync = ref.watch(testDetailProvider(testId));
    return testAsync.when(
      data: (test) => AssessmentRunnerScreen(test: test),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Failed to load test: $e',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
