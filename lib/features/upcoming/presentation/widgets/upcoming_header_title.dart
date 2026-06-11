import 'package:flutter/material.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';

class UpcomingHeaderTitle extends StatelessWidget {
  final TextTheme textTheme;
  final bool isDark;

  const UpcomingHeaderTitle({super.key, required this.textTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Tests',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'New assessments currently in development.',
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
