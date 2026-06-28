import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';

class TestSortMenu extends StatelessWidget {
  final String value;
  final bool sortAscending;
  final bool isDark;
  final TextTheme textTheme;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleDirection;

  final bool showLabel;

  const TestSortMenu({
    super.key,
    required this.value,
    required this.sortAscending,
    required this.isDark,
    required this.textTheme,
    required this.onChanged,
    required this.onToggleDirection,
    this.showLabel = true,
  });

  static const _labels = {
    'all': 'All',
    'name': 'Name',
    'time': 'Time',
    'severity': 'Severity',
    'items': 'Items',
    'newest': 'Newest',
  };

  static const _icons = {
    'all': LucideIcons.listChecks,
    'name': LucideIcons.arrowUpDown,
    'time': LucideIcons.clock,
    'severity': LucideIcons.shieldAlert,
    'items': LucideIcons.barChart3,
    'newest': LucideIcons.calendarDays,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          onSelected: onChanged,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedSm),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          constraints: const BoxConstraints.tightFor(width: 120),
          itemBuilder: (context) => [
            for (final entry in _labels.entries)
              PopupMenuItem(
                value: entry.key,
                height: 32,
                child: Row(
                  children: [
                    Icon(
                      _icons[entry.key],
                      size: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value,
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (value == entry.key) ...[
                      const Spacer(),
                      const Icon(Icons.check, size: 16,
                          color: AppColors.primary),
                    ],
                  ],
                ),
              ),
          ],
          child: Container(
            height: 40,
            width: showLabel ? 120 : 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: AppRadius.roundedSm,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.border,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icons[value] ?? LucideIcons.arrowUpDown,
                  size: 16,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 6),
                  Text(
                    _labels[value] ?? 'All',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: AppRadius.roundedSm,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border,
              width: 0.5,
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              sortAscending
                  ? LucideIcons.arrowUpNarrowWide
                  : LucideIcons.arrowDownWideNarrow,
              size: 18,
            ),
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            onPressed: onToggleDirection,
            visualDensity: VisualDensity.compact,
            tooltip: sortAscending ? 'Descending' : 'Ascending',
          ),
        ),
      ],
    );
  }
}
