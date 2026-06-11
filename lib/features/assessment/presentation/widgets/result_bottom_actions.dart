import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/features/assessment/presentation/dialogs/scoring_procedure_dialog.dart';

class ResultBottomActions extends StatelessWidget {
  final bool isDark;
  final bool isGeneratingPdf;
  final VoidCallback onSharePdf;
  final String? scoringProcedure;
  final String testId;

  const ResultBottomActions({
    super.key,
    required this.isDark,
    required this.isGeneratingPdf,
    required this.onSharePdf,
    required this.scoringProcedure,
    required this.testId,
  });

  @override
  Widget build(BuildContext context) {
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
              icon: isGeneratingPdf
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
                isGeneratingPdf
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
              onPressed: isGeneratingPdf ? null : onSharePdf,
            ),
          ),
          if (scoringProcedure != null &&
              scoringProcedure!.isNotEmpty) ...[
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
                    context, scoringProcedure!),
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
