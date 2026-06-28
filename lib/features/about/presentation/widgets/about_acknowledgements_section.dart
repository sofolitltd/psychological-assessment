import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/models/contributor.dart';
import 'about_info_card.dart';

class AboutAcknowledgementsSection extends StatelessWidget {
  final bool isDark;
  final TextTheme textTheme;

  const AboutAcknowledgementsSection({super.key, required this.isDark, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    final display = contributors.take(10).toList();
    final outfit = GoogleFonts.outfit();

    return AboutInfoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.users, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Acknowledgements', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: outfit.fontFamily), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => context.push('/about/acknowledgements'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('See More'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: display.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) => _ContributorAvatar(c: display[index]),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _ContributorAvatar extends StatelessWidget {
  final Contributor c;

  const _ContributorAvatar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(c.initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 64,
          child: Text(c.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontFamily: GoogleFonts.outfit().fontFamily)),
        ),
      ],
    );
  }
}
