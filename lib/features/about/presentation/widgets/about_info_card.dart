import 'package:flutter/material.dart';
import '../../../../core/design_system/app_theme.dart';

class AboutInfoCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const AboutInfoCard({super.key, required this.isDark, required this.child});

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
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
