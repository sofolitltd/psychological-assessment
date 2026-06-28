import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/app_theme.dart';

class MobileBottomNav extends StatelessWidget {
  final String currentTab;

  const MobileBottomNav({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return NavigationBar(
      maintainBottomViewPadding: true,
      height: 64,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
      indicatorColor: colors.primaryContainer,
      selectedIndex: currentTab == 'tests'
          ? 0
          : currentTab == 'upcoming'
            ? 1
            : currentTab == 'profile'
              ? 2
              : 3,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/upcoming');
          case 2:
            context.go('/profile');
          case 3:
            context.go('/about');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(LucideIcons.clipboardList, size: 18,),
          label: 'Tests',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.calendarClock, size: 18,),
          label: 'Upcoming',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.user, size: 18,),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.info, size: 18,),
          label: 'About',
        ),
      ],
    );
  }
}
