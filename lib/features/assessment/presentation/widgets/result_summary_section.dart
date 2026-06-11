import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/utils/severity_colors.dart';
import 'package:psychological_assessment/features/assessment/domain/scoring_engine.dart';

class ResultSummarySection extends StatelessWidget {
  final List<ScoreResult> scores;
  final bool isDark;

  const ResultSummarySection({
    super.key,
    required this.scores,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: severityColor(s.severity),
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
                    color: severityColor(s.severity).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    s.severity,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: severityColor(s.severity),
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
}
