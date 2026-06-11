import 'package:flutter/material.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';

class TestListHeaderTitle extends StatelessWidget {
  final TextTheme textTheme;
  final bool isDark;

  const TestListHeaderTitle({
    super.key,
    required this.textTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assessments',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Select a test to begin your assessment',
          style: textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
