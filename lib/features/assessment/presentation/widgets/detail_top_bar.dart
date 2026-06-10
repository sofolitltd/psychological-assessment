import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class DetailTopBar extends StatelessWidget {
  final bool isMobile;
  final String testName;

  const DetailTopBar({super.key, required this.isMobile, required this.testName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: [
          BreadcrumbItem(
            label: 'Tests',
            onTap: () => context.go('/'),
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(LucideIcons.chevronRight, size: 14),
          ),
          Text(
            testName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class BreadcrumbItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const BreadcrumbItem({
    super.key,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
