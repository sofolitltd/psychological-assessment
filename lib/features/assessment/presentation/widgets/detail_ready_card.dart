import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../domain/assessment_models.dart';

class DetailReadyCard extends StatelessWidget {
  final AssessmentTest test;
  final TestListItem? meta;

  const DetailReadyCard({super.key, required this.test, this.meta});

  Color get _color => meta?.themeColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
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
            Text(
              'শুরু করতে প্রস্তুত?',
              style: GoogleFonts.notoSerifBengali(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'এই পরীক্ষাটি সম্পূর্ণ করার জন্য পর্যাপ্ত সময় নিন এবং একটি শান্ত জায়গায় বসুন।',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.roundedSm,
                  ),
                ),
                onPressed: () => context.push('/test/${test.testId}/run'),
                icon: const Icon(LucideIcons.arrowRight, size: 18),
                label: Text(
                  'শুরু করুন',
                  style: GoogleFonts.notoSerifBengali(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            DetailTrustRow(
              icon: LucideIcons.lock,
              text: 'গোপনীয়তা নিশ্চিত করে',
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),

            const SizedBox(height: AppSpacing.sm),
            DetailTrustRow(
              icon: LucideIcons.wifiOff,
              text: 'অফলাইনে কাজ করে',
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),
            DetailTrustRow(
              icon: LucideIcons.zap,
              text: 'দ্রুতগতি সম্পন্ন',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTrustRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const DetailTrustRow({
    super.key,
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: GoogleFonts.notoSerifBengali(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
