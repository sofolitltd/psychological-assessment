import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/responsive.dart';
import '../../domain/assessment_models.dart';

class DetailStatsRow extends StatelessWidget {
  final AssessmentTest test;
  final TestListItem? meta;
  final bool isDark;
  final TextTheme textTheme;

  const DetailStatsRow({
    super.key,
    required this.test,
    this.meta,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final m = meta;
    final isMobile = Responsive.isMobile(context);

    final cards = <Widget>[
      DetailStatCard(
        icon: LucideIcons.helpCircle,
        title: 'Total Items',
        value: '${test.questions.length}',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.clock,
        title: 'Total Time',
        value: m?.estimatedTimeMinutes != null && m!.estimatedTimeMinutes > 0
            ? '${m.estimatedTimeMinutes} min'
            : '—',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.activity,
        title: 'Sensitivity',
        value: m?.sensitivityLevel != null && m!.sensitivityLevel.isNotEmpty
            ? m.sensitivityLevel
            : '—',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.folder,
        title: 'Category',
        value: test.category ?? 'General',
        isDark: isDark,
        textTheme: textTheme,
      ),
      DetailStatCard(
        icon: LucideIcons.barChart3,
        title: 'Total Scales',
        value: '${test.scales.length}',
        isDark: isDark,
        textTheme: textTheme,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: !isMobile
          ? Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: cards,
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cards
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: SizedBox(width: 145, child: c),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}

class DetailStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final TextTheme textTheme;

  const DetailStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
