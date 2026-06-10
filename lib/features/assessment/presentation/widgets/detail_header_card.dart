import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/responsive.dart';
import '../../domain/assessment_models.dart';
import 'detail_content_card.dart';

class DetailHeaderCard extends StatelessWidget {
  final AssessmentTest test;
  final IconData titleIcon;
  final Color titleColor;

  const DetailHeaderCard({
    super.key,
    required this.test,
    required this.titleIcon,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authorLines = (test.author != null && test.author != 'N/A')
        ? test.author!.split('\n').where((l) => l.trim().isNotEmpty).toList()
        : <String>[];

    return DetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: titleColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(titleIcon, size: 24, color: titleColor),
              ),
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Text(
                  test.testName,
                  style: GoogleFonts.outfit(
                    height: 1.2,
                    fontSize: Responsive.isDesktop(context)
                        ? 26
                        : Responsive.isTablet(context)
                            ? 22
                            : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (authorLines.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: authorLines.map((line) {
                  final isDev = line.trimLeft().startsWith('Developed');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isDev ? LucideIcons.microscope : LucideIcons.penTool,
                          size: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            line.trim(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
