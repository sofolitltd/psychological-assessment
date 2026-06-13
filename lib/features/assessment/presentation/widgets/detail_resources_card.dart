import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../domain/assessment_models.dart';
import 'package:psychological_assessment/features/assessment/presentation/dialogs/scoring_procedure_dialog.dart';

class DetailResourcesCard extends StatelessWidget {
  final AssessmentTest test;
  final bool isDark;
  final BuildContext outerContext;

  const DetailResourcesCard({
    super.key,
    required this.test,
    required this.isDark,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    final resources = test.resources ?? const AssessmentResources();
    final hasPdf = resources.banglaVersionUrl.isNotEmpty;
    final hasDoi = resources.banglaVersionDoi.isNotEmpty;
    final hasGuide =
        test.scoringProcedure != null && test.scoringProcedure!.isNotEmpty;

    if (!hasPdf && !hasGuide && !hasDoi) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.roundedMd,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 16,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'রিসোর্স',
                  style: GoogleFonts.notoSerifBengali(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (hasPdf)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedMd,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => context.push('/test/${test.testId}/pdf-viewer?url=${Uri.encodeComponent(resources.banglaVersionUrl)}&title=${Uri.encodeComponent(test.testName)}'),
                    icon: const Icon(LucideIcons.fileText, size: 18),
                    label: Text(
                      'মূল পিডিএফ',
                      style: GoogleFonts.notoSerifBengali(fontSize: 13),
                    ),
                  ),
                if (hasGuide)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedMd,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => showScoringProcedureDialog(
                      outerContext,
                      test.scoringProcedure!,
                    ),
                    icon: const Icon(LucideIcons.fileCheck, size: 18),
                    label: Text(
                      'স্কোরিং গাইড',
                      style: GoogleFonts.notoSerifBengali(fontSize: 13),
                    ),
                  ),
              ],
            ),
            if (hasDoi) ...[
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: () => launchUrl(
                  Uri.parse('https://doi.org/${resources.banglaVersionDoi}'),
                ),
                borderRadius: AppRadius.roundedSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.externalLink,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          'DOI: ${resources.banglaVersionDoi}',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
