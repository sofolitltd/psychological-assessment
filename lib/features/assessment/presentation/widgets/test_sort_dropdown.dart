import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class TestSortDropdown extends StatelessWidget {
  final String value;
  final bool isDark;
  final TextTheme textTheme;
  final ValueChanged<String> onChanged;

  const TestSortDropdown({
    super.key,
    required this.value,
    required this.isDark,
    required this.textTheme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            LucideIcons.arrowUpDown,
            size: 16,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'time', child: Text('Time')),
                DropdownMenuItem(value: 'severity', child: Text('Severity')),
                DropdownMenuItem(value: 'items', child: Text('Items')),
              ],
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
