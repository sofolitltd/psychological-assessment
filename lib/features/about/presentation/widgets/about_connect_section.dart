import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/design_system/app_theme.dart';
import 'about_info_card.dart';
import 'about_social_button.dart';

class AboutConnectSection extends StatelessWidget {
  final bool isDark;
  final TextTheme textTheme;

  const AboutConnectSection({super.key, required this.isDark, required this.textTheme});

  @override
  Widget build(BuildContext context) {
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
                child: const Icon(LucideIcons.messageCircle, size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text('Connect', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AboutSocialButton(icon: LucideIcons.messageSquare, label: 'Facebook', value: '/asifuzzamanreyad', url: 'https://www.facebook.com/asifuzzamanreyad', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          AboutSocialButton(icon: LucideIcons.messageCircle, label: 'WhatsApp', value: '+880 1704-340860', url: 'https://wa.me/+8801704340860', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          AboutSocialButton(icon: LucideIcons.briefcase, label: 'LinkedIn', value: '/in/asifuzzamanreyad', url: 'https://linkedin.com/in/asifuzzamanreyad', isDark: isDark, textTheme: textTheme),
          const SizedBox(height: AppSpacing.sm),
          AboutSocialButton(icon: LucideIcons.playCircle, label: 'YouTube', value: '@sofolitltd', url: 'https://youtube.com/@sofolitltd', isDark: isDark, textTheme: textTheme),
        ],
      ),
    );
  }
}
