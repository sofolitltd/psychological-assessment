import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import 'runner_question_navigator.dart';

class RunnerSidebar extends StatelessWidget {
  final int totalQuestions;
  final Set<int> answeredIndices;
  final double progress;
  final bool isComplete;
  final bool isDark;
  final ValueChanged<int> onTapNavigator;
  final VoidCallback? onSubmit;

  const RunnerSidebar({
    super.key,
    required this.totalQuestions,
    required this.answeredIndices,
    required this.progress,
    required this.isComplete,
    required this.isDark,
    required this.onTapNavigator,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, AppSpacing.md, AppSpacing.md, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: AppRadius.roundedMd,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
            ),
            child: RunnerQuestionNavigator(
              totalQuestions: totalQuestions,
              answeredCount: answeredIndices.length,
              answeredIndices: answeredIndices,
              isMobile: false,
              onTap: onTapNavigator,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(progress * 100).round()}% সম্পূর্ণ',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  color: AppColors.primary,
                  minHeight: 4,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: isComplete ? onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.roundedSm,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'মূল্যায়ন জমা দিন',
                          style: GoogleFonts.notoSerifBengali(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.arrowRight, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
