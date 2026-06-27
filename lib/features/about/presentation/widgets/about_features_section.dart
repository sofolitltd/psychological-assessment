import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/design_system/app_theme.dart';
import 'about_feature_row.dart';

class AboutFeaturesSection extends StatelessWidget {
  final bool isDark;
  final TextTheme textTheme;

  const AboutFeaturesSection({super.key, required this.isDark, required this.textTheme});

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
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                child: const Icon(LucideIcons.listChecks, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('Features', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AboutFeatureRow(icon: LucideIcons.clipboardList, title: 'Validated Assessments', subtitle: 'Evidence-based psychological instruments', isDark: isDark, textTheme: textTheme),
          AboutFeatureRow(icon: LucideIcons.barChart3, title: 'Detailed Results', subtitle: 'Comprehensive score breakdowns and interpretations', isDark: isDark, textTheme: textTheme),
          AboutFeatureRow(icon: LucideIcons.shield, title: 'Privacy First', subtitle: 'All data remains on your device', isDark: isDark, textTheme: textTheme),
          AboutFeatureRow(icon: LucideIcons.refreshCw, title: 'Regular Updates', subtitle: 'New tests and features added regularly', isDark: isDark, textTheme: textTheme),
        ],
      ),
    );
  }
}
