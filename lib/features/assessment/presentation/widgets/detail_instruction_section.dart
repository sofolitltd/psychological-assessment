import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class DetailInstructionSection extends StatelessWidget {
  final String text;
  final bool isDark;
  final TextTheme textTheme;

  const DetailInstructionSection({
    super.key,
    required this.text,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.info,
              size: 18,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'নির্দেশনা',
              style: GoogleFonts.notoSerifBengali(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          text,
          style: GoogleFonts.notoSerifBengali(
            fontSize: 14,
            height: 1.7,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
