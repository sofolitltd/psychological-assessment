import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/design_system/responsive.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_bundle.dart';
import 'package:psychological_assessment/features/assessment/domain/scoring_engine.dart';
import 'package:psychological_assessment/features/assessment/services/pdf_export_service.dart';
import 'package:psychological_assessment/features/assessment/domain/pdf_info_models.dart';
import 'package:psychological_assessment/features/assessment/presentation/dialogs/pdf_info_dialog.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/result_top_bar.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/result_score_card.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/result_summary_section.dart';
import 'package:psychological_assessment/features/assessment/presentation/widgets/result_bottom_actions.dart';
import 'package:psychological_assessment/features/auth/domain/auth_gate.dart';

class AssessmentResultsScreen extends ConsumerStatefulWidget {
  final AssessmentResultBundle bundle;

  const AssessmentResultsScreen({super.key, required this.bundle});

  @override
  ConsumerState<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState extends ConsumerState<AssessmentResultsScreen> {
  bool _isGeneratingPdf = false;

  void _onSharePdf() {
    final gate = requireAuth(context, ref, () async {
      final userInfo = await showPdfInfoDialog(context);
      if (userInfo == null) return;

      setState(() => _isGeneratingPdf = true);
      try {
        final pdfBytes = await PdfExportService.generateAssessmentReport(
          widget.bundle,
          clientName: userInfo.name,
          clientId: userInfo.clientId,
          clientPhone: userInfo.phone,
          fullReport: userInfo.reportType == PdfType.full,
        );
        final fileName =
            '${widget.bundle.testName.replaceAll(' ', '_')}_Report.pdf';
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to generate PDF: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isGeneratingPdf = false);
      }
    });
    gate();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final scores = widget.bundle.scores.values.toList();
    final maxWidth = Responsive.maxContentWidth(context);

    return Title(
      title: '${widget.bundle.testName} - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                Expanded(
                  child: isMobile
                      ? _buildMobileLayout(isDark, scores)
                      : _buildDesktopLayout(isDark, scores),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildMobileLayout(bool isDark, List<ScoreResult> scores) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      children: [
        ResultTopBar(
          testId: widget.bundle.testId,
          testName: widget.bundle.testName,
          scaleCount: scores.length,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ResultSummarySection(scores: scores, isDark: isDark),
              const SizedBox(height: AppSpacing.md),
              ...scores.map((result) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: ResultScoreCard(
                  result: result,
                  resultBands: widget.bundle.test.resultBands,
                  isDark: isDark,
                ),
              )),
              const SizedBox(height: AppSpacing.md),
              ResultBottomActions(
                isDark: isDark,
                isGeneratingPdf: _isGeneratingPdf,
                onSharePdf: _onSharePdf,
                scoringProcedure: widget.bundle.test.scoringProcedure,
                testId: widget.bundle.testId,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isDark, List<ScoreResult> scores) {
    final isDesktop = Responsive.isDesktop(context);
    final leftFlex = isDesktop ? 4 : 3;
    final rightFlex = isDesktop ? 3 : 2;
    final gap = isDesktop ? 24.0 : 16.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ResultTopBar(
              testId: widget.bundle.testId,
              testName: widget.bundle.testName,
              scaleCount: scores.length,
              isDark: isDark,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverFillRemaining(
          hasScrollBody: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: leftFlex,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                  children: scores.map((result) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: ResultScoreCard(
                      result: result,
                      resultBands: widget.bundle.test.resultBands,
                      isDark: isDark,
                    ),
                  )).toList(),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                flex: rightFlex,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResultSummarySection(scores: scores, isDark: isDark),
                      const SizedBox(height: AppSpacing.md),
                      ResultBottomActions(
                        isDark: isDark,
                        isGeneratingPdf: _isGeneratingPdf,
                        onSharePdf: _onSharePdf,
                        scoringProcedure: widget.bundle.test.scoringProcedure,
                        testId: widget.bundle.testId,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
