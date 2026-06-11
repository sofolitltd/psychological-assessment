import 'package:flutter/material.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';
import 'package:psychological_assessment/features/assessment/presentation/providers/assessment_notifier.dart';
import 'package:psychological_assessment/features/assessment/presentation/dialogs/scoring_procedure_dialog.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_instruction_card.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_question_card.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_submit_button.dart';

class RunnerQuestionListView extends StatelessWidget {
  final bool isDark;
  final List<TestQuestion> visibleQuestions;
  final Map<int, int> responses;
  final AssessmentNotifier notifier;
  final Map<int, GlobalKey> questionKeyMap;
  final ScrollController scrollController;
  final String? instruction;
  final String? scoringProcedure;
  final List<TestQuestion> allQuestions;
  final List<TestOption> defaultOptions;
  final bool showSubmit;
  final bool includeInstruction;
  final VoidCallback? onFinish;

  const RunnerQuestionListView({
    super.key,
    required this.isDark,
    required this.visibleQuestions,
    required this.responses,
    required this.notifier,
    required this.questionKeyMap,
    required this.scrollController,
    this.instruction,
    this.scoringProcedure,
    required this.allQuestions,
    required this.defaultOptions,
    this.showSubmit = false,
    this.includeInstruction = false,
    this.onFinish,
  });

  static const _estimateItemHeight = 180.0;

  List<TestQuestion> _getVisibleQuestions(Map<int, int> resp) {
    return allQuestions.where((q) {
      if (q.showIf == null) return true;
      return resp[q.showIf!.questionId] == q.showIf!.value;
    }).toList();
  }

  void _scrollToNextUnanswered(
    List<TestQuestion> visible,
    Map<int, int> resp,
    BuildContext context,
  ) {
    final nextIndex = visible.indexWhere(
      (q) => !resp.containsKey(q.id),
    );
    if (nextIndex < 0) return;
    final ctx = questionKeyMap[visible[nextIndex].id]?.currentContext;
    if (ctx != null && ctx.findRenderObject() != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
      return;
    }

    final padding = AppSpacing.md;
    final roughOffset =
        padding + nextIndex * (_estimateItemHeight + AppSpacing.md);
    scrollController.jumpTo(
      roughOffset.clamp(0.0, scrollController.position.maxScrollExtent),
    );

    Future(() {
      if (!context.mounted) return;
      final updatedVisible = _getVisibleQuestions(resp);
      final updatedIndex = updatedVisible.indexWhere(
        (q) => !resp.containsKey(q.id),
      );
      if (updatedIndex < 0) return;
      final retryCtx =
          questionKeyMap[updatedVisible[updatedIndex].id]?.currentContext;
      if (retryCtx == null) return;
      if (!retryCtx.mounted) return;
      Scrollable.ensureVisible(
        retryCtx,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasInstruction = includeInstruction &&
        instruction != null &&
        instruction!.isNotEmpty;
    final isComplete = notifier.isComplete(visibleQuestions.length);

    final children = <Widget>[];
    if (hasInstruction) {
      children.add(RunnerInstructionCard(
        instruction: instruction,
        scoringProcedure: scoringProcedure,
        isDark: isDark,
        margin: const EdgeInsets.only(top: 4, bottom: 24),
        onScoringInfo: () {
          showScoringProcedureDialog(context, scoringProcedure!);
        },
      ));
    }
    for (final question in visibleQuestions) {
      final selected = responses[question.id];
      final displayNumber =
          allQuestions.indexWhere((q) => q.id == question.id) + 1;
      children.add(RunnerQuestionCard(
        key: questionKeyMap[question.id],
        question: question,
        options: question.options ?? defaultOptions,
        selectedValue: selected,
        questionNumber: displayNumber,
        onChanged: (val) {
          if (val != null) {
            final newResp = Map<int, int>.from(responses);
            newResp[question.id] = val;
            for (final q in allQuestions) {
              if (q.showIf?.questionId == question.id &&
                  q.showIf?.value != val) {
                newResp.remove(q.id);
                notifier.clearResponse(q.id);
              }
            }
            notifier.setResponse(question.id, val);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              final newVis = _getVisibleQuestions(newResp);
              _scrollToNextUnanswered(newVis, newResp, context);
            });
          }
        },
      ));
      children.add(const SizedBox(height: 10));
    }
    if (showSubmit) {
      children.add(RunnerSubmitButton(
        isComplete: isComplete,
        onSubmit: onFinish,
      ));
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      children: children,
    );
  }
}
