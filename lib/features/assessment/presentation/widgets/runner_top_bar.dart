import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class RunnerTopBar extends StatelessWidget {
  final String testName;
  final int answeredCount;
  final int totalQuestions;
  final bool isDark;
  final VoidCallback onBack;

  const RunnerTopBar({
    super.key,
    required this.testName,
    required this.answeredCount,
    required this.totalQuestions,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$answeredCount / $totalQuestions উত্তরিত',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
