import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class RunnerInstructionCard extends StatelessWidget {
  final String? instruction;
  final String? scoringProcedure;
  final bool isDark;
  final VoidCallback? onScoringInfo;
  final EdgeInsetsGeometry? margin;

  const RunnerInstructionCard({
    super.key,
    required this.instruction,
    this.scoringProcedure,
    required this.isDark,
    this.onScoringInfo,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    if (instruction == null || instruction!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
        ),
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Text(
              instruction!,
              style: TextStyle(
                fontSize: 14,
                fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
          if (scoringProcedure != null && scoringProcedure!.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.info),
              tooltip: 'স্কোরিং পদ্ধতি',
              onPressed: onScoringInfo,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
