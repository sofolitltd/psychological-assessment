import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'app_theme.dart';
import 'theme_notifier.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  static const _labels = {
    ThemeMode.light: 'Light',
    ThemeMode.dark: 'Dark',
    ThemeMode.system: 'System',
  };

  static const _icons = {
    ThemeMode.light: LucideIcons.sun,
    ThemeMode.dark: LucideIcons.moon,
    ThemeMode.system: LucideIcons.monitor,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<ThemeMode>(
      onSelected: (mode) =>
          ref.read(themeModeProvider.notifier).setThemeMode(mode),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedSm),
      color: isDark ? AppColors.surfaceDark : Colors.white,
      constraints: const BoxConstraints.tightFor(width: 120),
      itemBuilder: (context) => [
        for (final entry in _labels.entries)
          PopupMenuItem(
            value: entry.key,
            height: 32,
            child: SizedBox(
              child: Row(
                children: [
                  Icon(
                    _icons[entry.key],
                    size: 14,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  if (currentMode == entry.key) ...[
                    const Spacer(),
                    const Icon(Icons.check, size: 16,
                        color: AppColors.primary),
                  ],
                ],
              ),
            ),
          ),
      ],
        child: Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: AppRadius.roundedSm,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border,
              width: 0.5,
            ),
          ),
          child: Icon(
            _icons[currentMode] ?? LucideIcons.monitor,
            size: 18,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
    );
  }
}