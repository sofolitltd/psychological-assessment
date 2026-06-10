import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/design_system/app_theme.dart';

class DetailAboutSection extends StatelessWidget {
  final String text;
  final bool isDark;
  final TextTheme textTheme;

  const DetailAboutSection({
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
        Text(
          'সম্পর্কে',
          style: GoogleFonts.notoSerifBengali(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          text,
          style: GoogleFonts.notoSerifBengali(
            fontSize: 15,
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
