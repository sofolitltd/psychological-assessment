import 'package:flutter/material.dart';

import '../../../../core/design_system/app_theme.dart';

class TestFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  const TestFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : isDark
                  ? AppColors.surfaceDark
                  : AppColors.surface,
          borderRadius: AppRadius.roundedSm,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : isDark
                    ? AppColors.borderDark
                    : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? Colors.white : null,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 4),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : isDark
                        ? AppColors.textSecondaryDark.withValues(alpha: 0.2)
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
