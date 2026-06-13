import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/extensions.dart';

class RunnerQuestionNavigator extends StatelessWidget {
  final int totalQuestions;
  final int answeredCount;
  final Set<int> answeredIndices;
  final int? currentIndex;
  final bool isMobile;
  final void Function(int index)? onTap;
  final ScrollController? scrollController;

  const RunnerQuestionNavigator({
    super.key,
    required this.totalQuestions,
    required this.answeredCount,
    required this.answeredIndices,
    this.currentIndex,
    this.isMobile = false,
    this.onTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return SizedBox(
        height: 40,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: totalQuestions,
          itemBuilder: (context, index) {
            final isAnswered = answeredIndices.contains(index);
            final isCurrent = currentIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _GridDot(
                index: index,
                isAnswered: isAnswered,
                isCurrent: isCurrent,
                isDark: isDark,
                onTap: onTap,
              ),
            );
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(
            'প্রশ্ন নির্দেশিকা',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            '${answeredCount.bn} / ${totalQuestions.bn} উত্তরিত',
            style: TextStyle(
              fontSize: 12,
              fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(totalQuestions, (index) {
            final isAnswered = answeredIndices.contains(index);
            final isCurrent = currentIndex == index;
            return _GridDot(
              index: index,
              isAnswered: isAnswered,
              isCurrent: isCurrent,
              isDark: isDark,
              onTap: onTap,
            );
          }),
        ),
      ],
    );
  }
}

class _GridDot extends StatelessWidget {
  final int index;
  final bool isAnswered;
  final bool isCurrent;
  final bool isDark;
  final void Function(int index)? onTap;

  const _GridDot({
    required this.index,
    required this.isAnswered,
    required this.isCurrent,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCurrent
        ? AppColors.primary
        : isAnswered
            ? Colors.green
            : (isDark ? AppColors.borderDark : AppColors.border);

    return GestureDetector(
      onTap: onTap != null ? () => onTap!(index) : null,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primary.withValues(alpha: 0.15)
              : isAnswered
                  ? Colors.green.withValues(alpha: 0.15)
                  : null,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: isCurrent ? 2 : 1.5),
        ),
        child: Text(
          (index + 1).bn,
          style: TextStyle(
            fontSize: 12,
            fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
            fontWeight: isCurrent || isAnswered ? FontWeight.bold : FontWeight.normal,
            color: isCurrent
                ? AppColors.primary
                : isAnswered
                    ? Colors.green
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
