import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/assessment_repository.dart';
import 'assessment_results_screen.dart';

class ResultScreenLoader extends ConsumerWidget {
  final String testId;
  const ResultScreenLoader({super.key, required this.testId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bundle = ref.watch(resultBundleProvider)[testId];
    if (bundle == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return AssessmentResultsScreen(bundle: bundle);
  }
}
