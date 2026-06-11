import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:psychological_assessment/core/design_system/app_theme.dart';
import 'package:psychological_assessment/core/design_system/responsive.dart';
import 'package:psychological_assessment/core/design_system/theme_toggle_button.dart';

class WebTopNav extends StatelessWidget {
  final String currentTab;

  const WebTopNav({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Responsive.maxContentWidth(context),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/data/logo.png',
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Psychological',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.2,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Assessment',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                      letterSpacing: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _NavItem(
                label: 'Tests',
                isActive: currentTab == 'tests',
                onTap: () => context.go('/'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _NavItem(
                label: 'Upcoming',
                isActive: currentTab == 'upcoming',
                onTap: () => context.go('/upcoming'),
              ),
              const SizedBox(width: AppSpacing.sm),
              _NavItem(
                label: 'About',
                isActive: currentTab == 'about',
                onTap: () => context.go('/about'),
              ),
              const SizedBox(width: AppSpacing.sm),
              const ThemeToggleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}
