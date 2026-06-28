import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/design_system/app_theme.dart';
import 'about_info_card.dart';

class AboutDeveloperSection extends StatelessWidget {
  final bool isDark;
  final TextTheme textTheme;

  const AboutDeveloperSection({
    super.key,
    required this.isDark,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AboutInfoCard(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  LucideIcons.user,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Developer',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.network(
              'https://reyad.vercel.app/_next/image?url=%2Freyad1.png&w=256&q=75',
              height: 72,
              width: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: Text(
                  'MR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Md Asifuzzaman Reyad',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'B.Sc, M.Sc in Psychology, University of Chittagong',
            style: textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),

          Text(
            'Psychosocial Counselor, P2H Project, Bangladesh Red Crescent Society',
            textAlign: .center,
            style: textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
