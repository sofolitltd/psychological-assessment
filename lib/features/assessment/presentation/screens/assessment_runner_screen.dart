import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/design_system/responsive.dart';
import 'package:psychological_assessment/features/assessment/data/assessment_repository.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_bundle.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';
import 'package:psychological_assessment/features/assessment/domain/scoring_engine.dart';
import 'package:psychological_assessment/features/assessment/presentation/providers/assessment_notifier.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_question_list_view.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_question_navigator.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_sidebar.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/runner_top_bar.dart';

class AssessmentRunnerScreen extends ConsumerStatefulWidget {
  final AssessmentTest test;

  const AssessmentRunnerScreen({super.key, required this.test});

  @override
  ConsumerState<AssessmentRunnerScreen> createState() =>
      _AssessmentRunnerScreenState();
}

class _AssessmentRunnerScreenState
    extends ConsumerState<AssessmentRunnerScreen> {
  final _scrollController = ScrollController();
  final _navScrollController = ScrollController();
  late final Map<int, GlobalKey> _questionKeyMap;
  static const _estimateItemHeight = 180.0;

  @override
  void initState() {
    super.initState();
    _questionKeyMap = {
      for (final q in widget.test.questions) q.id: GlobalKey(),
    };
    _scrollController.addListener(_syncNavScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(assessmentProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncNavScroll);
    _scrollController.dispose();
    _navScrollController.dispose();
    super.dispose();
  }

  void _syncNavScroll() {
    if (!_scrollController.hasClients || !_navScrollController.hasClients) return;
    final scrollOffset = _scrollController.offset;
    final padding = AppSpacing.md;
    final index = ((scrollOffset - padding) / (_estimateItemHeight + AppSpacing.md))
        .round()
        .clamp(0, _scrollController.position.maxScrollExtent ~/ (_estimateItemHeight + AppSpacing.md).toInt());
    const navItemWidth = 38.0;
    final navTarget = AppSpacing.md + index * navItemWidth + navItemWidth / 2
        - _navScrollController.position.viewportDimension / 2;
    _navScrollController.jumpTo(
      navTarget.clamp(0.0, _navScrollController.position.maxScrollExtent),
    );
  }

  List<TestQuestion> _getVisibleQuestions(Map<int, int> responses) {
    return widget.test.questions.where((q) {
      if (q.showIf == null) return true;
      return responses[q.showIf!.questionId] == q.showIf!.value;
    }).toList();
  }

  void _scrollToQuestionIndex(int index) {
    final visible = _getVisibleQuestions(ref.read(assessmentProvider).responses);
    if (index >= visible.length) return;
    final ctx = _questionKeyMap[visible[index].id]?.currentContext;
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
    final roughOffset = padding + index * (_estimateItemHeight + AppSpacing.md);
    _scrollController.jumpTo(
      roughOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );

    Future(() {
      if (!mounted) return;
      final updatedVisible = _getVisibleQuestions(ref.read(assessmentProvider).responses);
      if (index >= updatedVisible.length) return;
      final retryCtx = _questionKeyMap[updatedVisible[index].id]?.currentContext;
      if (retryCtx == null) return;
      if(!retryCtx.mounted) return;
      Scrollable.ensureVisible(
        retryCtx,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    });
  }

  void _finishAssessment(Map<int, int> responses) {
    final engine = ScoringEngineFactory.forTest(widget.test.testId);
    final rawScores = engine.calculate(
      responses,
      widget.test.questions,
      widget.test.maxOptionValue,
    );

    final enrichedScores = enrichResults(rawScores, widget.test.resultBands);

    final bundle = AssessmentResultBundle(
      testId: widget.test.testId,
      testName: widget.test.testName,
      scores: enrichedScores,
      rawResponses: responses,
      test: widget.test,
    );

    ref.read(resultBundleProvider.notifier).save(widget.test.testId, bundle);
    context.pushReplacement(
      '/test/${widget.test.testId}/result',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final state = ref.watch(assessmentProvider);
    final notifier = ref.read(assessmentProvider.notifier);

    final visibleQuestions = _getVisibleQuestions(state.responses);
    final progress = notifier.getProgress(visibleQuestions.length);
    final isComplete = notifier.isComplete(visibleQuestions.length);
    final answeredCount = state.responses.length;

    final answeredIndices = <int>{};
    for (int i = 0; i < visibleQuestions.length; i++) {
      if (state.responses.containsKey(visibleQuestions[i].id)) {
        answeredIndices.add(i);
      }
    }

    return Title(
      title: '${widget.test.testName} - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                RunnerTopBar(
                  testName: widget.test.testName,
                  answeredCount: answeredCount,
                  totalQuestions: visibleQuestions.length,
                  isDark: isDark,
                  onBack: () => context.pop(),
                ),
                if (isMobile)
                  _buildProgressBar(isDark, progress),
                if (isMobile)
                  _buildMobileNavigator(
                    isDark,
                    visibleQuestions.length,
                    answeredIndices,
                  ),
                if (isMobile) ...[
                  Expanded(child: RunnerQuestionListView(
                    isDark: isDark,
                    visibleQuestions: visibleQuestions,
                    responses: state.responses,
                    notifier: notifier,
                    questionKeyMap: _questionKeyMap,
                    scrollController: _scrollController,
                    instruction: widget.test.instruction,
                    scoringProcedure: widget.test.scoringProcedure,
                    allQuestions: widget.test.questions,
                    defaultOptions: widget.test.options,
                    includeInstruction: true,
                    showSubmit: true,
                    onFinish: () => _finishAssessment(state.responses),
                  )),
                ] else
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Expanded(
                            flex: Responsive.isDesktop(context) ? 4 : 3,
                            child: RunnerQuestionListView(
                              isDark: isDark,
                              visibleQuestions: visibleQuestions,
                              responses: state.responses,
                              notifier: notifier,
                              questionKeyMap: _questionKeyMap,
                              scrollController: _scrollController,
                              instruction: widget.test.instruction,
                              scoringProcedure: widget.test.scoringProcedure,
                              allQuestions: widget.test.questions,
                              defaultOptions: widget.test.options,
                              includeInstruction: true,
                              showSubmit: false,
                            ),
                          ),
                        SizedBox(
                          width: Responsive.isDesktop(context) ? 24 : 16,
                        ),
                        Expanded(
                          flex: Responsive.isDesktop(context) ? 3 : 2,
                          child:                          RunnerSidebar(
                            totalQuestions: visibleQuestions.length,
                            answeredIndices: answeredIndices,
                            progress: progress,
                            isComplete: isComplete,
                            isDark: isDark,
                            onTapNavigator: _scrollToQuestionIndex,
                            onSubmit: () =>
                                _finishAssessment(state.responses),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),)
    );
  }

  Widget _buildProgressBar(bool isDark, double progress) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      color: AppColors.primary,
      minHeight: 3,
    );
  }

  Widget _buildMobileNavigator(
    bool isDark,
    int totalQuestions,
    Set<int> answeredIndices,
  ) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RunnerQuestionNavigator(
        scrollController: _navScrollController,
        totalQuestions: totalQuestions,
        answeredCount: answeredIndices.length,
        answeredIndices: answeredIndices,
        isMobile: true,
        onTap: _scrollToQuestionIndex,
      ),
    );
  }
}
