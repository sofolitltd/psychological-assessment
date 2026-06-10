import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';
import '../../../assessment/domain/assessment_models.dart';
import 'detail_lucide_icon_map.dart';

Color _sensitivityColor(String level) {
  switch (level) {
    case 'High':
      return const Color(0xFFE53935);
    case 'Medium':
      return const Color(0xFFFB8C00);
    case 'Low':
      return const Color(0xFF43A047);
    default:
      return const Color(0xFFD9D7D7);
  }
}

class TestCard extends StatefulWidget {
  final TestListItem test;
  final bool uniformHeight;

  const TestCard({super.key, required this.test, this.uniformHeight = false});

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final test = widget.test;
    final color = test.themeColor;
    final icon = lucideIconMap[test.lucideIconName] ?? LucideIcons.clipboardList;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? Matrix4.translationValues(0, -2, 0)
            : Matrix4.identity(),
        child: Material(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.surface.withValues(alpha: 0.85),
          borderRadius: AppRadius.roundedMd,
          elevation: _isHovered ? 4 : 2,
          shadowColor: AppColors.cardShadow,
          child: InkWell(
            onTap: () => context.push('/test/${test.id}'),
            borderRadius: AppRadius.roundedMd,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: AppRadius.roundedMd,
                border: Border.all(
                  color: _isHovered
                      ? color.withValues(alpha: 0.4)
                      : isDark
                          ? AppColors.borderDark
                          : AppColors.border,
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, size: 18, color: color),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          test.name,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (test.estimatedTimeMinutes > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                    .withValues(alpha: 0.15)
                                : AppColors.textSecondary
                                    .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.clock,
                                size: 10,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${test.estimatedTimeMinutes}m',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
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
                  const SizedBox(height: AppSpacing.md),
                  if (widget.uniformHeight)
                    Expanded(
                      child: Text(
                        test.description,
                        style: GoogleFonts.tiroBangla(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Text(
                      test.description,
                      style: GoogleFonts.tiroBangla(
                        fontSize: 13,
                        height: 1.4,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          test.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (test.reliabilityBadge.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.border.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            test.reliabilityBadge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (test.sensitivityLevel.isNotEmpty)
                            Container(
                              width: 8,
                              height: 8,
                              margin:
                                  const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _sensitivityColor(
                                    test.sensitivityLevel),
                              ),
                            ),
                          if (test.questionCount > 0)
                            Text(
                              '${test.questionCount} items',
                              style: textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
