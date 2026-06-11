import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/utils/severity_colors.dart';
import 'package:psychological_assessment/features/assessment/domain/assessment_models.dart';
import 'package:psychological_assessment/features/assessment/domain/scoring_engine.dart';

class ResultScoreCard extends StatelessWidget {
  final ScoreResult result;
  final Map<String, List<ResultBand>> resultBands;
  final bool isDark;

  const ResultScoreCard({
    super.key,
    required this.result,
    required this.resultBands,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = severityColor(result.severity);
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
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

          if (resultBands.containsKey(result.scale)) ...[
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: AppRadius.roundedSm,
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    for (final band in resultBands[result.scale]!)
                      Expanded(
                        flex: (band.maxScore - band.minScore) + 1,
                        child: Container(
                          color: severityColorFromBand(
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
            ...resultBands[result.scale]!.map((band) {
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
                            ? severityColor(band.status)
                            : severityColor(band.status).withValues(alpha: 0.25),
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
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
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
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
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
                color: color.withValues(alpha: 0.08),
                borderRadius: AppRadius.roundedSm,
              ),
              child: Text(
                result.interpretation!,
                style: GoogleFonts.tiroBangla(
                  fontSize: 15,
                  color: color.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ),
          ],

          if (result.suggestions != null &&
              result.suggestions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'পরামর্শ:',
              style: TextStyle(
                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                fontWeight: FontWeight.bold,
              ),
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
}
