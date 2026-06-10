import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:printing/printing.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import '../domain/assessment_bundle.dart';
import '../services/pdf_export_service.dart';
import 'scoring_procedure_dialog.dart';

class AssessmentResultsScreen extends StatefulWidget {
  final AssessmentResultBundle bundle;

  const AssessmentResultsScreen({super.key, required this.bundle});

  @override
  State<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState extends State<AssessmentResultsScreen> {
  bool _isGeneratingPdf = false;

  Future<void> _sharePdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      final pdfBytes = await PdfExportService.generateAssessmentReport(
        widget.bundle,
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
  }

  Color _severityColor(String severity) {
    final s = severity.toLowerCase();
    if (s.contains('normal') || s.contains('no risk') || s.contains('no love'))
      return Colors.green;
    if (s.contains('mild') || s.contains('low')) return Colors.amber.shade700;
    if (s.contains('moderate') || s.contains('probable')) return Colors.orange;
    if (s.contains('extremely') ||
        s.contains('high') ||
        s.contains('excessive'))
      return const Color(0xFFB71C1C);
    if (s.contains('severe')) return Colors.red;
    return AppColors.textSecondary;
  }

  Color _severityColorFromBand(String bandStatus, String currentSeverity) {
    if (bandStatus == currentSeverity) return _severityColor(bandStatus);
    return _severityColor(bandStatus).withValues(alpha: 0.35);
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
                if (!isMobile) ...[
                  const SizedBox(height: 16),
                  _buildTopBar(isDark, scores),
          // const SizedBox(height: 12),
                ],
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

  Widget _buildTopBar(bool isDark, List scores) {
    final scaleCount = scores.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.roundedMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(LucideIcons.chevronLeft, size: 16, color: Colors.white),
              label: const Text(
                'Back',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedSm,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Assessment Result',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.bundle.testName,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildWhiteChip(
                  '$scaleCount ${scaleCount == 1 ? 'Scale' : 'Scales'}',
                  LucideIcons.barChart3,
                ),
                const SizedBox(width: 8),
                _buildWhiteChip(
                  'Completed',
                  LucideIcons.checkCircle2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: AppRadius.roundedSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isDark, List scores) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      children: [
        _buildTopBar(isDark, scores),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildSummarySection(isDark, scores),
              const SizedBox(height: AppSpacing.md),
              ...scores.map((result) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _buildScoreCard(result, isDark),
              )),
              const SizedBox(height: AppSpacing.md),
              _buildBottomActions(isDark),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(bool isDark, List scores) {
    final isDesktop = Responsive.isDesktop(context);
    final leftFlex = isDesktop ? 4 : 3;
    final rightFlex = isDesktop ? 3 : 2;
    final gap = isDesktop ? 24.0 : 16.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: leftFlex,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            children: scores.map((result) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _buildScoreCard(result, isDark),
            )).toList(),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: rightFlex,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(isDark, scores),
                const SizedBox(height: AppSpacing.md),
                _buildBottomActions(isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(dynamic result, bool isDark) {
    final color = _severityColor(result.severity);
    final max = result.maxScore > 0 ? result.maxScore : 1;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                result.scale.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Text(
                  result.severity,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result.rawScore}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  '/ $max',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          if (widget.bundle.test.resultBands.containsKey(
            result.scale,
          )) ...[
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: AppRadius.roundedSm,
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    for (final band
                        in widget.bundle.test.resultBands[result.scale]!)
                      Expanded(
                        flex: (band.maxScore - band.minScore) + 1,
                        child: Container(
                          color: _severityColorFromBand(
                            band.status,
                            result.severity,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...widget.bundle.test.resultBands[result.scale]!.map((
              band,
            ) {
              final isCurrent = band.status == result.severity;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? _severityColor(band.status)
                            : _severityColor(
                                band.status,
                              ).withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        band.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrent
                              ? (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary)
                              : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary),
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      '${band.minScore}${band.minScore != band.maxScore ? ' - ${band.maxScore}' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrent
                            ? (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary)
                            : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary),
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          if (result.interpretation != null &&
              result.interpretation!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: AppRadius.roundedSm,
              ),
              child: Text(
                result.interpretation!,
                style: GoogleFonts.tiroBangla(
                  fontSize: 15,
                  color: color.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
          ],

          if (result.suggestions != null &&
              result.suggestions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Text(
              'পরামর্শ:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              result.suggestions!,
              style: GoogleFonts.tiroBangla(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummarySection(bool isDark, List scores) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.barChart3, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                'সারসংক্ষেপ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...scores.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: _severityColor(s.severity),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    s.scale[0].toUpperCase() + s.scale.substring(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _severityColor(s.severity).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    s.severity,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _severityColor(s.severity),
                      fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${s.rawScore}/${s.maxScore}'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )),
          if (scores.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'কোন ফলাফল পাওয়া যায়নি',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: _isGeneratingPdf
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.fileDown, size: 18),
              label: Text(
                _isGeneratingPdf
                    ? 'PDF তৈরি হচ্ছে...'
                    : 'ফলাফল ডাউনলোড',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedSm,
                ),
              ),
              onPressed: _isGeneratingPdf ? null : _sharePdf,
            ),
          ),
          if (widget.bundle.test.scoringProcedure != null &&
              widget.bundle.test.scoringProcedure!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Divider(
              color: isDark ? AppColors.borderDark : AppColors.border,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                icon: const Icon(LucideIcons.fileText, size: 18),
                label: Text(
                  'স্কোরিং পদ্ধতি দেখুন',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm,
                  ),
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.border,
                  ),
                ),
                onPressed: () => showScoringProcedureDialog(
                    context, widget.bundle.test.scoringProcedure!),
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              icon: const Icon(LucideIcons.home, size: 18),
              label: Text(
                'হোম পেজে ফিরুন',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedSm,
                ),
                side: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.border,
                ),
              ),
              onPressed: () => context.go('/'),
            ),
          ),
        ],
      ),
    );
  }
}
