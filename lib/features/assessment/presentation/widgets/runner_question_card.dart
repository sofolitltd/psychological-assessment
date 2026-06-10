import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../domain/assessment_models.dart';

class RunnerQuestionCard extends StatelessWidget {
  final TestQuestion question;
  final List<TestOption> options;
  final int? selectedValue;
  final int questionNumber;
  final ValueChanged<int?> onChanged;

  const RunnerQuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.questionNumber,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAnswered = selectedValue != null;

    final borderColor = isAnswered
        ? Colors.green
        : (isDark ? AppColors.borderDark : AppColors.border);
    final borderWidth = isAnswered ? 1.5 : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isAnswered
                        ? Colors.green
                        : AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$questionNumber',
                    style: TextStyle(
                      color: isAnswered ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _OptionRow(
                    label: opt.label,
                    isSelected: selectedValue == opt.value,
                    isDark: isDark,
                    onTap: () => onChanged(opt.value),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _OptionRow({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderCol = isSelected
        ? Colors.green
        : (isDark ? AppColors.borderDark : AppColors.border);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.roundedSm,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withValues(alpha: 0.08)
              : null,
          borderRadius: AppRadius.roundedSm,
          border: Border.all(
            color: borderCol,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : borderCol,
                  width: 1.5,
                ),
                color: isSelected ? Colors.green : Colors.transparent,
              ),
              child: isSelected
                  ? Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontFamily: GoogleFonts.notoSerifBengali().fontFamily,
                  color: isSelected
                      ? Colors.green
                      : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
