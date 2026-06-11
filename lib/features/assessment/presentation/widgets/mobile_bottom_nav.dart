import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/design_system/app_theme.dart';

class MobileBottomNav extends StatelessWidget {
  final String currentTab;

  const MobileBottomNav({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        currentIndex: currentTab == 'tests'
            ? 0
            : currentTab == 'upcoming'
              ? 1
              : 2,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/upcoming');
          case 2:
            context.go('/about');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.clipboardList),
          label: 'Tests',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.calendarClock),
          label: 'Upcoming',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.info),
          label: 'About',
        ),
      ],
      ),
    );
  }
}
