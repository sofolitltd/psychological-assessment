import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/responsive.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/web_top_nav.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Title(
      title: '404 - Psychological Assessment',
      color: AppColors.primary,
      child: Scaffold(
        body: Column(
          children: [
            if (!isMobile)
              const WebTopNav(currentTab: ''),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.fileQuestion,
                        size: 80,
                        color: isDark
                            ? AppColors.textSecondaryDark.withValues(alpha: 0.5)
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'পৃষ্ঠাটি পাওয়া যায়নি',
                        style: GoogleFonts.notoSerifBengali(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'আপনি যে পৃষ্ঠাটি খুঁজছেন তা বিদ্যমান নেই।',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(LucideIcons.home, size: 18),
                        label: Text(
                          'হোম পেজে ফিরুন',
                          style: GoogleFonts.notoSerifBengali(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.roundedMd,
                          ),
                          side: BorderSide(
                            color: isDark ? AppColors.borderDark : AppColors.border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isMobile)
              const MobileBottomNav(currentTab: ''),
          ],
        ),
      ),
    );
  }
}
