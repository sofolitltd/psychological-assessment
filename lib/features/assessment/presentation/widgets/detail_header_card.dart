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
    final notoSerif = GoogleFonts.notoSerifBengali();
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
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.scrollText, size: 14, color: Colors.blue),
              ),
              const SizedBox(width: 10),
              Text('স্বীকৃতি', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: notoSerif.fontFamily)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'আমরা ধীরে ধীরে তথ্য সংগ্রহ করছি এবং এই উদ্যোগকে এগিয়ে নিচ্ছি। '
      'লেখক এবং অভিযোজকের প্রতি আমরা অত্যন্ত শ্রদ্ধাশীল ও কৃতজ্ঞ। '
      'কোনো ভুল তথ্য বা তথ্যের ঘাটতি থাকলে আমরা আন্তরিকভাবে দুঃখিত,'
      'কারণ আমাদের কপিরাইট সংক্রান্ত বিষয়গুলো বিবেচনা করতে হচ্ছে।',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
              fontFamily: notoSerif.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
